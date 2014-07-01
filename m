Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbaGAMVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 08:21:43 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:55583 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbaGAMVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 08:21:42 -0400
Message-ID: <53B2A7D4.4020007@linaro.org>
Date: Tue, 01 Jul 2014 07:21:40 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: bcm@fixthebug.org, mporter@linaro.org,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mach-bcm SMC: address clang inline asm incompatibility
References: <1404216339-6480-1-git-send-email-elder@linaro.org> <20140701121544.GK32514@n2100.arm.linux.org.uk>
In-Reply-To: <20140701121544.GK32514@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 07:15 AM, Russell King - ARM Linux wrote:
> On Tue, Jul 01, 2014 at 07:05:39AM -0500, Alex Elder wrote:
>> My GCC-based build environment likes to call register r12 by the
>> name "ip" in inline asm.  Behan Webster informed me that his Clang-
>> based build environment likes "r12" instead.
> 
> Two objections, one of which is an acceptable outcome:
> 1. Why can't clang just learn these alternative names?

I suggested that.  I don't know where to send that suggestion
though.

> 2. Why can't we just use "r12" here?

I don't recall the details, but when I wrote the code originally
that way it gave me errors.  It's why I had the "Also called r12"
comment next to the symbol declaration.

I agree, I'd rather have either one of those than this #ifdef
workaround.  I was supplying this as a potentially quicker fix
for the problem Behan was hitting.

					-Alex
