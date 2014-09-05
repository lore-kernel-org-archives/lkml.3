Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaIEVdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:33:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51808 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592AbaIEVdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:33:45 -0400
Message-ID: <540A2B9A.1070707@zytor.com>
Date: Fri, 05 Sep 2014 14:31:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>,
        ron minnich <rminnich@gmail.com>
CC: Gerd Hoffmann <kraxel@redhat.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        coreboot <coreboot@coreboot.org>
Subject: Re: [coreboot] [PATCH] x86: add coreboot framebuffer support
References: <1409826307-23075-1-git-send-email-kraxel@redhat.com>	<540A17A6.1000802@zytor.com>	<540A266F.80503@gmail.com> <CAP6exYJj8Fupa1uTLRP5uGoWNjvwKo7bAAPvYmzUYB=AOqOq8g@mail.gmail.com> <540A29E6.2080405@gmail.com>
In-Reply-To: <540A29E6.2080405@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 02:23 PM, Vladimir 'φ-coder/phcoder' Serbinenko wrote:
> On 06.09.2014 00:18, ron minnich wrote:
>> Vladimir can you point me to that patch? This sounds
>> interesting.
>> 
> https://lkml.org/lkml/2010/8/25/190
> 

I believe *most* of this patch has already gotten merged as we now use
simplefb on x86 as well.  So all we need is probably the ID.

	-hpa

