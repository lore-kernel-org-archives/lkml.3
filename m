Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbaDKWSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 18:18:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48367 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbaDKWSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 18:18:40 -0400
Message-ID: <53486A30.80909@zytor.com>
Date: Fri, 11 Apr 2014 15:18:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>
CC: Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on 64-bit
 kernels
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com> <53483487.6030103@zytor.com> <53485BB8.1000106@mit.edu> <53485D95.9030301@zytor.com> <5348643F.1020405@mit.edu> <534865DF.2090703@linux.intel.com> <CALCETrX4BLLL1Con7+Fr5cfodHQs40qA4TE39yop2NeARdwA+A@mail.gmail.com>
In-Reply-To: <CALCETrX4BLLL1Con7+Fr5cfodHQs40qA4TE39yop2NeARdwA+A@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 03:15 PM, Andy Lutomirski wrote:
> 
> I just looked up my hideous code.  I was doing this to test the
> now-deleted int 0xcc vsyscall stuff.  I used modify_ldt because either
> I didn't realize that __USER32_CS was usable or I didn't think it was
> ABI.  Or I was just being silly.
> 
> But yes, breaking my hack would not matter. :)
> 

Either way, it wouldn't break it.

	-hpa


