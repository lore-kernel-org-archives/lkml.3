Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab3DYJlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:41:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:43046 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171Ab3DYJlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:41:12 -0400
Date: Thu, 25 Apr 2013 11:41:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@alien8.de>
cc: vitalif@yourcmc.ru, Ben Hutchings <ben@decadent.org.uk>,
        "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        700333@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>
Subject: Re: Bug#700333: Stack trace
In-Reply-To: <alpine.LFD.2.02.1304221409420.21884@ionos>
Message-ID: <alpine.LFD.2.02.1304251139340.21884@ionos>
References: <4bded8a24b0719d575f6ffa6b38aebb6@yourcmc.ru> <1362490501.3768.409.camel@deadeye.wl.decadent.org.uk> <1b81bc6219ee47a5b8e53d03e9944939@yourcmc.ru> <20130305203952.GZ9079@decadent.org.uk> <4e8c511dcfd811c0f2ab822adaf52e50@yourcmc.ru>
 <1362536476.3768.416.camel@deadeye.wl.decadent.org.uk> <15ec7b46ebd929a67caea0d80b324af9@yourcmc.ru> <1362971451.3937.29.camel@deadeye.wl.decadent.org.uk> <cc9020446ea75ed733ec96c505039f2a@yourcmc.ru> <20130420225516.GB4649@pd.tnic>
 <alpine.LFD.2.02.1304221409420.21884@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Apr 2013, Thomas Gleixner wrote:
> With the patch below, the box should survive and we should see a 
> 
> "Spurious HPET timer interrupt on HPET timer..." entry in dmesg.
> 
> That's a first workaround to confirm my theory. I'll look into the
> HPET code how we can avoid that at all.

Looks like we can't do anything about that in the HPET code itself.

Vitaliy, could you try that patch ?

Thanks,

	tglx
