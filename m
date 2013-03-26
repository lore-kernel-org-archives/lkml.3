Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933978Ab3CZCrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 22:47:53 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:38626 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933944Ab3CZCrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 22:47:53 -0400
Date: Mon, 25 Mar 2013 22:47:49 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Chen Gang <gang.chen@asianux.com>
cc: Greg KH <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] include/linux/platform_data: beautify code, 'inline' is
 better in front of 'void'
In-Reply-To: <515107DB.4060508@asianux.com>
Message-ID: <alpine.LFD.2.03.1303252246540.1372@syhkavp.arg>
References: <514FB826.9020302@asianux.com> <20130325233213.GA29245@kroah.com> <5150F871.5050306@asianux.com> <20130326014830.GB6496@kroah.com> <515107DB.4060508@asianux.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Mar 2013, Chen Gang wrote:

>   a hacker may find something "valuable" with the aid of compiler   ;-)
> 
>   maybe, it is a patch which is too minor to apply. I can understand :-)

You should send such patches to Jiri Kosina <trivial@kernel.org>.


Nicolas
