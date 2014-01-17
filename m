Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaAQFRD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 00:17:03 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:53083 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaAQFRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 00:17:00 -0500
MIME-Version: 1.0
In-Reply-To: <20140116213206.GG8919@ld-irv-0074>
References: <1389773306-7055-1-git-send-email-prabhakar.csengg@gmail.com> <20140116213206.GG8919@ld-irv-0074>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 17 Jan 2014 10:46:38 +0530
Message-ID: <CA+V-a8u42eNcDoSr42Bq-3JJEdFMXjru-PDpmXqjZEzkoQ=efQ@mail.gmail.com>
Subject: Re: [PATCH] mtd: davinci_nand: Remove unnecessary labels from error path
To: Brian Norris <computersforpeace@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

On Fri, Jan 17, 2014 at 3:02 AM, Brian Norris
<computersforpeace@gmail.com> wrote:
> On Wed, Jan 15, 2014 at 01:38:26PM +0530, Prabhakar Lad wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> This patch removes the unnecessary labels from
>> the error path in probe function which did nothing
>> than just returning error values, Thus simplifying code
>> path and improved readability.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
> This does not apply to my branch, since some OOM messages have been
> dropped. Can you rebase on l2-mtd.git (or linux-next)?
>
OK I'll rebase it against linux-next and post a v2.

Thanks,
--Prabhakar Lad
