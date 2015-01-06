Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbbAFCUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 21:20:20 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:58618 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbbAFCUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 21:20:18 -0500
MIME-Version: 1.0
In-Reply-To: <20141228235637.GA27095@bbox>
References: <1419599095-4382-1-git-send-email-opensource.ganesh@gmail.com> <20141228235637.GA27095@bbox>
From: Dan Streetman <ddstreet@ieee.org>
Date: Mon, 5 Jan 2015 21:19:51 -0500
X-Google-Sender-Auth: sZWR6px7PVd7-r2Oo-VoApswGZw
Message-ID: <CALZtONATN5xj22qRxFWRXOtpQVRa0LXqLLbv7BKcLuKevKkPqw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/zpool: add name argument to create zpool
To: Minchan Kim <minchan@kernel.org>
Cc: Ganesh Mahendran <opensource.ganesh@gmail.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2014 at 6:56 PM, Minchan Kim <minchan@kernel.org> wrote:
> On Fri, Dec 26, 2014 at 09:04:55PM +0800, Ganesh Mahendran wrote:
>> Currently the underlay of zpool: zsmalloc/zbud, do not know
>> who creates them. There is not a method to let zsmalloc/zbud
>> find which caller they belogs to.
>>
>> Now we want to add statistics collection in zsmalloc. We need
>> to name the debugfs dir for each pool created. The way suggested
>> by Minchan Kim is to use a name passed by caller(such as zram)
>> to create the zsmalloc pool.
>>     /sys/kernel/debug/zsmalloc/zram0
>>
>> This patch adds a argument *name* to zs_create_pool() and other
>> related functions.
>>
>> Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
> Acked-by: Minchan Kim <minchan@kernel.org>

Acked-by: Dan Streetman <ddstreet@ieee.org>

>
> --
> Kind regards,
> Minchan Kim
