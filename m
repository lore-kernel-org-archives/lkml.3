Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaC2JNN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 05:13:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:56878 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaC2JNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 05:13:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris BREZILLON <b.brezillon.dev@gmail.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: Re: [RFC PATCH v2 03/10] ARM: at91: introduce OLD_IRQ_AT91 Kconfig option
Date: Sat, 29 Mar 2014 10:12:54 +0100
Message-ID: <7407417.cSDunZuEhW@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140329100639.5ea454bc@skate>
References: <1396029548-10928-1-git-send-email-b.brezillon.dev@gmail.com> <1396029548-10928-4-git-send-email-b.brezillon.dev@gmail.com> <20140329100639.5ea454bc@skate>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:HgMVhetCnQRFLWLQDWJOQ+iwIz4bsrJkHsZ4Miq+Xcv
 VESCWgbWbhqqYykFXZQx2poA4K4vgXM/dcmJ4HErgPFeDVfcAZ
 FbrNPs2FHCFkIP91TdAbbD84JRDoBxmg2eAhO2mtklaSIyt7SG
 zRz7PdwPwRsCUUxkFimlXKjb0g7Tj2Pllfy4jKBNQkLHDaVGX8
 +BOO6SIWSh9g8FP3ykItHrFfFDZEAqDJPJ7+nH3XjZmJP+V5br
 5itnLtV+iDL4fpB3owvZZ2JB5Xd5zzs4Qwn8L/fKa5jd3awQVI
 EIUl+mK+5xQTqjCIMxerRKFd2Z3YeiGfA/FaRZd1jTHatJrpLm
 SWA2v7ln//wF+9e7UDGY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 March 2014 10:06:39 Thomas Petazzoni wrote:
> Dear Boris BREZILLON,
> 
> On Fri, 28 Mar 2014 18:59:01 +0100, Boris BREZILLON wrote:
> 
> > +config OLD_IRQ_AT91
> > +     bool
> > +     default false
> 
> I don't think "default false" is a valid Kconfig construct. It could be
> "default n", but that's useless since "default n" is the default
> behavior. So I believe you can simply get rid of that line.

I think the above is syntactically correct, but it would be highly confusing in
anyone ever does

config false
	def_bool y

;-)

Aside from that, these three have completely identical meaning:

config OLD_IRQ_AT91
	bool

config OLD_IRQ_AT91
	def_bool n

config OLD_IRQ_AT91
	bool
	default n

	Arnd


