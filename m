Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaIONmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 09:42:37 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:40653 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbaIONmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 09:42:36 -0400
Message-ID: <5416ECC4.1020200@codethink.co.uk>
Date: Mon, 15 Sep 2014 14:42:28 +0100
From: Rob Jones <rob.jones@codethink.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-kernel@codethink.co.uk
Subject: Re: [PATCH 1/2] fs: proc: use __seq_open_private()
References: <1410530978-29627-1-git-send-email-rob.jones@codethink.co.uk>	<1410530978-29627-2-git-send-email-rob.jones@codethink.co.uk> <20140912145456.863d25e38db6fa5dea60845d@linux-foundation.org>
In-Reply-To: <20140912145456.863d25e38db6fa5dea60845d@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/09/14 22:54, Andrew Morton wrote:
> On Fri, 12 Sep 2014 15:09:37 +0100 Rob Jones <rob.jones@codethink.co.uk> wrote:
>
>> Reduce boilerplate code by using __seq_open_private() instead of seq_open().
>
> http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch
> already did this.
>

Great. Too recent to be in my source tree though, I'm afraid.

Even so, it's nice to see that his code is identical to mine (except
for the assign-on-declaration, I prefer the whitespace, but hey).

I wonder if this was triggered by my documentation patch for the
routine. If so, that makes me happy :-)

-- 
Rob Jones
Codethink Ltd
mailto:rob.jones@codethink.co.uk
tel:+44 161 236 5575
