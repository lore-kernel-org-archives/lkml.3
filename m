Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbaKSQ0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:26:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37951 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbaKSQ0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:26:32 -0500
Message-ID: <546CC49B.2070109@zytor.com>
Date: Wed, 19 Nov 2014 08:26:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Thelen <gthelen@google.com>, Junjie Mao <eternal.n08@gmail.com>
CC: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Vivek Goyal <vgoyal@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3] x86, kaslr: Prevent .bss from overlaping initrd
References: <1414762838-13067-1-git-send-email-eternal.n08@gmail.com> <xr9361ed9rrj.fsf@gthelen.mtv.corp.google.com> <xr934mtx9rgx.fsf@gthelen.mtv.corp.google.com>
In-Reply-To: <xr934mtx9rgx.fsf@gthelen.mtv.corp.google.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2014 06:23 PM, Greg Thelen wrote:
> 
> On Mon, Nov 17 2014, Greg Thelen wrote:
> [...]
>> Given that bss and brk are nobits (i.e. only ALLOC) sections, does
>> file_offset make sense as a load address.  This fails with gold:
>>

It really doesn't.  We have that information elsewhere.

	-hpa


