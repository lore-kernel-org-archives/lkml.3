Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaIEVXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:23:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51717 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbaIEVXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:23:06 -0400
Message-ID: <540A2907.9080100@zytor.com>
Date: Fri, 05 Sep 2014 14:20:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>, linux-kernel@vger.kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        coreboot@coreboot.org
Subject: Re: [coreboot] [PATCH] x86: add coreboot framebuffer support
References: <1409826307-23075-1-git-send-email-kraxel@redhat.com> <540A17A6.1000802@zytor.com> <540A266F.80503@gmail.com>
In-Reply-To: <540A266F.80503@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 02:09 PM, Vladimir 'φ-coder/phcoder' Serbinenko wrote:
> 
>> I'm not a fan of Coreboot having invented its own nonstandard
>> hacks, but I guess it is pretty much unavoidable.
> It's completely avoidable. The stub can copy this information to 
> standard framebuffer info structure. The only missing thing is to
> apply patch by cjwatson or mjg59 (I'm not sure now who wrote it)
> for having an ID for linear framebuffer which implies no specific
> hardware (it can be any) or firmware (coreboot doesn't provide nay
> additional info or callback).
> 
> Please don't apply this patch it will break SeaBIOS booting with
> VGABIOS.
> 

Thanks for the warning.  Yes, this is the Right Thing.

	-hpa

