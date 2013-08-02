Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab3HBMpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 08:45:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:49065 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab3HBMpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 08:45:21 -0400
Message-ID: <51FBA9CC.2090206@linutronix.de>
Date: Fri, 02 Aug 2013 14:45:00 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.10.4-rt1
References: <alpine.DEB.2.02.1308011215160.4089@ionos.tec.linutronix.de>  <CAP=VYLp1ERhS4cFtgXGHL2DfCGoJ9VbPvShH5ZOWCpPuSzQY6w@mail.gmail.com> <1375419917.3743.93.camel@pasglop>
In-Reply-To: <1375419917.3743.93.camel@pasglop>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 07:05 AM, Benjamin Herrenschmidt wrote:
> On Thu, 2013-08-01 at 20:03 -0400, Paul Gortmaker wrote:
>> I've added Ben to the CC in case he has a suggestion on
>> how best to fix this, even though it is not yet mainline.
> 
> Can you exchange with a TIF_ that isn't used in asm ? For example
> TIF_PERFMON_* ? Keep all the asm ones below 16 and move up the ones
> that are used in C only ?

I going to look later at this. I think I swapped one of the TIF_
defines in v3.8 so it should work.

> 
> Cheers,
> Ben.
> 

Sebastian
