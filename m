Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbaDNP0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:26:53 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37904 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbaDNP0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:26:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140408131256.GA5637@e103592.cambridge.arm.com>
References: <1395852549-2745-1-git-send-email-jay.foad@gmail.com>
	<20140408131256.GA5637@e103592.cambridge.arm.com>
Date: Mon, 14 Apr 2014 16:26:49 +0100
Message-ID: <CANd1uZmHi2PB0FLZ8zox_X2kbaMz_td0xqo7PkC3bP1jQNMfSw@mail.gmail.com>
Subject: Re: [PATCH] ARM: VFP: Fix emulation of multiply accumulate instructions
From: Jay Foad <jay.foad@gmail.com>
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 April 2014 14:13, Dave Martin <Dave.Martin@arm.com> wrote:
> On Wed, Mar 26, 2014 at 04:49:09PM +0000, Jay Foad wrote:
>> The emulation for single and double precision multiply accumulate
>> instructions correctly normalised any denormal values in the operand
>> registers, but failed to normalise the destination (accumulator)
>> register.
>>
>> This fixes https://bugzilla.kernel.org/show_bug.cgi?id=70501
>>
>> Signed-off-by: Jay Foad <jay.foad@gmail.com>
>
> Reviewed-by: Dave Martin <Dave.Martin@arm.com>
>
> This appears to be clean and straightforward, so if nobody else has
> commented on this by the time -rc1 comes out, I suggest you rebase it
> and send it to the patch system.  (See
> http://www.arm.linux.org.uk/developer/patches/info.php for details
> -- make sure you read it carefully.)

Done.

> Has this issue been hitting real-world users of the kernel, or is
> this fixing a latent bug?

Real world: it was causing failures in the test suite for an APL
interpreter running on the Raspberry Pi.

Thanks,
Jay.
