Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306AbaEEXen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 19:34:43 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:35022 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246AbaEEXem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 19:34:42 -0400
Date: Tue, 6 May 2014 00:34:41 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Alessandro Zummo <a.zummo@towertech.it>
cc: John Stultz <john.stultz@linaro.org>, Randy Dunlap <rdunlap@infradead.org>,
        Stefani Seibold <stefani@seibold.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: X86: Impossible select Enhanced Real Time Clock Support (legacy
 PC RTC driver)
In-Reply-To: <20140428202034.782de089@linux.lan.towertech.it>
Message-ID: <alpine.LFD.2.11.1405060026210.21408@eddie.linux-mips.org>
References: <1397415946.1555.16.camel@vger.seibold.net>        <53555C56.1040900@infradead.org>        <CALAqxLVVGM2nON71BbhuD-7eXnqbKGomfL63COaT7nePuQQ=zg@mail.gmail.com> <20140428202034.782de089@linux.lan.towertech.it>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2014, Alessandro Zummo wrote:

> > But it sounds like the driver/char/rtc bit is dead code, and needs a
> > cleanup? Or is there some use of that code that you need that the
> > generic RTC layer doesn't have?
> 
>  as far as I know, no recent distribution is using the old code anymore 
>  and the new (well, not so new anymore) framework provides the same 
>  functionality.

 Well, the handling of update-ended interrupts is still missing, as is 
some non-x86 stuff I posted a fix for recently (still pending review, can 
you please look into it sometime?).

  Maciej
