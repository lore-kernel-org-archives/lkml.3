Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936498Ab3DILhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 07:37:46 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:42190 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759399Ab3DILhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 07:37:45 -0400
Date: Tue, 9 Apr 2013 13:37:42 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Subject: Re: mfd: Core driver for Winbond chips
Message-ID: <20130409113742.GC7867@spo001.leaseweb.com>
References: <1362957300-18223-1-git-send-email-linux@roeck-us.net> <20130322205258.GE7867@spo001.leaseweb.com> <20130323002810.GA26245@roeck-us.net> <20130323174914.GA21563@roeck-us.net> <20130409093700.GM24058@zurbaran>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409093700.GM24058@zurbaran>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

> > MFD core driver for various variants of Winbond/Nuvoton SuperIO chips.
> > 
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> >  drivers/mfd/Kconfig          |   22 +++
> >  drivers/mfd/Makefile         |    1 +
> >  drivers/mfd/w83627hf-core.c  |  324 ++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/mfd/w83627hf.h |  131 +++++++++++++++++
> >  4 files changed, 478 insertions(+)
> >  create mode 100644 drivers/mfd/w83627hf-core.c
> >  create mode 100644 include/linux/mfd/w83627hf.h
> This driver looks overall good to me. Is this your final version, or should I
> expect any follow up patch ?

If possible could you wait a couple of days. I need to review it with what I had created
so that Guenter and Myself can come up with a final version.

Kind regards,
Wim.

