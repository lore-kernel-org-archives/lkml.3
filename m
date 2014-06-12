Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbaFLMTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:19:10 -0400
Received: from void.printf.net ([89.145.121.20]:53876 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbaFLMTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:19:05 -0400
From: Chris Ball <chris@printf.net>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Turquette <mturquette@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [GIT PULL] MMC updates for 3.16-rc1
References: <86ha3so84o.fsf@void.printf.net>
	<CA+55aFxBwteZeUHG+Z-cdLU_YCO4f8TDuYvGmXc0-v9M1H11+g@mail.gmail.com>
	<20140612071744.GA11421@lee--X1>
Date: Thu, 12 Jun 2014 13:19:00 +0100
In-Reply-To: <20140612071744.GA11421@lee--X1> (Lee Jones's message of "Thu, 12
	Jun 2014 08:17:44 +0100")
Message-ID: <86lht2mibv.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 12 2014, Lee Jones wrote:
>> And I'm not sure why the sunxi driver (by David Lanzendörfer) and the
>> Realtek driver (by Roger Tseng) got merged in two different trees.
>> It's clearly the same patches and drivers, but I got them first
>> through the MFD tree (Realtek) and the clock tree (sunxi) trees and
>> now the MMC tree.
>> 
>> Don't you guys talk to each other? The Realtek driver is even marked
>> as Acked-by Chris Ball in the MFD tree.
>
> Yes, we do talk to each other.  Branch ib-mfd-mmc-memstick-3.16 was
> created as a result.  Based on no facts at all, I'm guessing that the
> shared (immutable) branch wasn't applied correctly in the MMC tree.

Yes, our fault -- I gave my Ack, but then Ulf sent me the driver in his
PR and I pulled it.  Sorry for all the trouble, it was the first cycle
with Ulf and I co-maintaining, and a larger set of commits than usual.
We'll make sure to do better.

Thanks,

- Chris.
-- 
Chris Ball   <http://printf.net/>
