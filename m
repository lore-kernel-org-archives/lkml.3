Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbaAQHvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 02:51:00 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33529 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaAQHu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 02:50:57 -0500
MIME-Version: 1.0
In-Reply-To: <CA+V-a8u42eNcDoSr42Bq-3JJEdFMXjru-PDpmXqjZEzkoQ=efQ@mail.gmail.com>
References: <1389773306-7055-1-git-send-email-prabhakar.csengg@gmail.com>
 <20140116213206.GG8919@ld-irv-0074> <CA+V-a8u42eNcDoSr42Bq-3JJEdFMXjru-PDpmXqjZEzkoQ=efQ@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 17 Jan 2014 13:20:36 +0530
Message-ID: <CA+V-a8sNSKX_W43G7A0zFKq1GX7k25XR2ZxVtxiQyAmLD5Rs4w@mail.gmail.com>
Subject: Re: [PATCH] mtd: davinci_nand: Remove unnecessary labels from error path
To: Brian Norris <computersforpeace@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brain,

On Fri, Jan 17, 2014 at 10:46 AM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:
> Hi Brian,
>
> On Fri, Jan 17, 2014 at 3:02 AM, Brian Norris
> <computersforpeace@gmail.com> wrote:
>> On Wed, Jan 15, 2014 at 01:38:26PM +0530, Prabhakar Lad wrote:
>>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>>
>>> This patch removes the unnecessary labels from
>>> the error path in probe function which did nothing
>>> than just returning error values, Thus simplifying code
>>> path and improved readability.
>>>
>>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> This does not apply to my branch, since some OOM messages have been
>> dropped. Can you rebase on l2-mtd.git (or linux-next)?
>>
> OK I'll rebase it against linux-next and post a v2.
>
My Bad was too late, there is already a patch fixing the above issue
in linux-next
please ignore this patch.

Thanks,
--Prabhakar Lad
