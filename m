Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbaIZNeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 09:34:12 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:61108 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbaIZNeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 09:34:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Ley Foon Tan <lftan@altera.com>, Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3 01/29] asm-generic: add generic futex for !CONFIG_SMP
Date: Fri, 26 Sep 2014 15:33:50 +0200
Message-ID: <2108931.btbn8ltBxI@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140926131746.GA3279@distanz.ch>
References: <1410168160-3624-1-git-send-email-lftan@altera.com> <3608975.MxU44B73lk@wuerfel> <20140926131746.GA3279@distanz.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:JtR+/YWgpUlgNhlx62kk0Z4SxVkUtOuYzgMt5JCyNHE
 Hv3TQCOpIEkdZTd0iP2dp8GSc963eHUlzkI4uhFNWo0QLPxPpq
 PH1qqGGTeTrLpXczb8HeCzBRJlhtmMUmUIpJI/6ufrBXsPBop+
 obm6i+ILhp82VrfxgDrs4ozJAmjG+l5r/EQ4Njk1D5rtE1apm1
 E2Imp2vIbxAMpHpU10cAAN/Bv4KaS/+ureHUASKITHVsKfwMMU
 jMqkLQsHqaKdyIYcxM2JmCmspI0sX/jMBwsIP0QF4BkwmGw9zE
 6DyTQgH655Nkl4Ys1hizlWWnPkE3Kfvpc214YIz2W4wJ39uOTN
 uFmNqQiVVEOWrRqrPaP0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 September 2014 15:17:46 Tobias Klauser wrote:
> Speaking of the nios2 part: I'm the author of some parts of this code,
> but now also reviewed this series (or rather, intend to do so for the
> few remaining patches I didn't review yet).
> 
> What is the appropriate way to account for this? Is Reviewed-By still OK? I
> guess I won't be considered an entirely neutral reviewer 
> 

I think Reviewed-by is fine here, ideally mention in the full text
description who wrote what.

	Arnd
