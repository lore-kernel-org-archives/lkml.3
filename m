Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513Ab3CMO0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 10:26:55 -0400
Received: from void.printf.net ([89.145.121.20]:59633 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756411Ab3CMO0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 10:26:53 -0400
From: Chris Ball <cjb@laptop.org>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: "'Markos Chandras'" <markos.chandras@imgtec.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>
Subject: Re: [PATCH 1/3] dw_mmc: Don't loop when handling an interrupt
References: <1363085593-22214-1-git-send-email-markos.chandras@imgtec.com>
	<002501ce1ff6$38e3c470$aaab4d50$%jun@samsung.com>
Date: Wed, 13 Mar 2013 10:26:46 -0400
In-Reply-To: <002501ce1ff6$38e3c470$aaab4d50$%jun@samsung.com> (Seungwon
	Jeon's message of "Wed, 13 Mar 2013 23:22:40 +0900")
Message-ID: <87a9q7fk9l.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 13 2013, Seungwon Jeon wrote:
> On Tuesday, March 12, 2013, Markos Chandras wrote:
>> There is no reason to loop when handling an interrupt. The "if" clauses
>> will handle all of them sequentially. This also eliminates the extra loop
>> we used to take with no pending interrupts and we ended up breaking out
>> of the while loop.
>> 
>> Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
>> Cc: Seungwon Jeon <tgih.jun@samsung.com>
>
> Acked-by: Seungwon Jeon <tgih.jun@samsung.com>
>
> You can add my ack to other patches.
> However, could you change the subject prefix to 'mmc: dw_mmc' and resend?

It's okay, I'll take care of that when applying this time.  Thanks!

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
