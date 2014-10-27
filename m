Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaJ0BXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 21:23:48 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:33839 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbaJ0BXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 21:23:47 -0400
MIME-Version: 1.0
In-Reply-To: <20141026014143.GA3328@gmail.com>
References: <000001cff035$c060dc60$41229520$%yang@samsung.com>
	<20141026014143.GA3328@gmail.com>
Date: Mon, 27 Oct 2014 09:23:46 +0800
Message-ID: <CAL1ERfM-w-pDsL+SSEwnPSmkXWeRGBDeQjMoc5wfSqC4zfneFg@mail.gmail.com>
Subject: Re: [PATCH 1/2] zram: make max_used_pages reset work correctly
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Weijie Yang <weijie.yang@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Streetman <ddstreet@ieee.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Nitin Gupta <ngupta@vflare.org>, Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2014 at 9:41 AM, Minchan Kim <minchan@kernel.org> wrote:
> Hello,
>
> On Sat, Oct 25, 2014 at 05:25:11PM +0800, Weijie Yang wrote:
>> The commit 461a8eee6a ("zram: report maximum used memory") introduces a new
>> knob "mem_used_max" in zram.stats sysfs, and wants to reset it via write 0
>> to the sysfs interface.
>>
>> However, the current code cann't reset it correctly, so let's fix it.
>
> We wanted to reset it to current used total memory, not 0.

I misread taht, I will resend the 2/2 patch

> --
> Kind regards,
> Minchan Kim
