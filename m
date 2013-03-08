Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934372Ab3CHQTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 11:19:15 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61424 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136Ab3CHQTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 11:19:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: Re: [PATCH 2/3] x86, pci sta2x11-fixup: add function to access sta2x11 instance id
Date: Fri, 8 Mar 2013 16:13:34 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        rubini@gnudd.com, sameo@linux.intel.com, giancarlo.asnaghi@st.com,
        mturquette@linaro.org, linus.walleij@linaro.org,
        rob.herring@calxeda.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
References: <1362756691-14736-1-git-send-email-ciminaghi@gnudd.com> <1362756691-14736-3-git-send-email-ciminaghi@gnudd.com>
In-Reply-To: <1362756691-14736-3-git-send-email-ciminaghi@gnudd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303081613.34371.arnd@arndb.de>
X-Provags-ID: V02:K0:1QhhIUF+4CQ7CWOV/9/MBGoKMIHnXqoUIx7jkL4PkVv
 ktvgF3opr7UwK8drvakqZvOxF9mvTKSxtq8+OTfeMnKbk/3vmP
 Bv/7kr8iLMSDljBkZbZNUMdY6cXToLr2ICwMU3KNo+y8r3Z8rH
 /9vvMPaYpEmL8yDuy/UxxbHoQbLrqd/R+7uk1WJS0nKF0cAKSF
 LaD3irI79GeREz2AMn7x25Q9/uRPTOrD0VaVeHVORRTli8pBDA
 yU17Wwuq0qdzgm9b4u/fkHPffsTzoAls840qTZ6NRxhPYlOCPF
 ekq/7LTE+8I5cy2nP03H+TYW724XfeeC0m3mNYEbeFiVFKrsiR
 pfiE9kxL6UtX4kNosX+c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 March 2013, Davide Ciminaghi wrote:
> 
> The sta2x11 instance id will be included in clock names to make them
> unique in case of multiple sta2x11's living on the same machine.
> 
> Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>

I might be missing something, but this seems counterintuitive. Shouldn't
the clock names really be constant and independent of the instance?

The instance should be identified already by the dev_name, right?

	Arnd
