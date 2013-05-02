Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab3EBLVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 07:21:23 -0400
Received: from mail.nanl.de ([217.115.11.12]:40120 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab3EBLVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 07:21:22 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1305021241040.3972@ionos>
References: <20522420.158691367384219315.JavaMail.weblogic@epml17>
 <CAOiHx=mBPHmDse4EwL-+Fgmpz0=XhcgF_0nWdyvErFO4NU7E0Q@mail.gmail.com> <alpine.LFD.2.02.1305021241040.3972@ionos>
From: Jonas Gorski <jogo@openwrt.org>
Date: Thu, 2 May 2013 13:20:56 +0200
Message-ID: <CAOiHx=mA-htk_2daeE9WpbEVV9YLvfLc1NYZZR=JeDdibchCnw@mail.gmail.com>
Subject: Re: mips; boot fail after merge 3.9+
To: Thomas Gleixner <tglx@linutronix.de>
Cc: eunb.song@samsung.com, "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 12:42 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Does the patch below fix your issue ?

Does not work for me either. I don't even have SMP enabled, so this
codepath isn't taken for me at all.


Jonas
