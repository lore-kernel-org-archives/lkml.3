Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbaI2Kw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 06:52:56 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35210 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaI2Kwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 06:52:43 -0400
Message-ID: <54293975.9040402@gmail.com>
Date: Mon, 29 Sep 2014 16:20:29 +0530
From: Kiran Padwal <kiran.padwal21@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tanya Brokhman <tlinder@codeaurora.org>
CC: dedeking1@gmail.com, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtd: ubi: Extend UBI layer debug/messaging capabilities
References: <1411886185-7838-1-git-send-email-tlinder@codeaurora.org>
In-Reply-To: <1411886185-7838-1-git-send-email-tlinder@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tanya,

On Sunday 28 September 2014 12:06 PM, Tanya Brokhman wrote:
> If there is more then one UBI device mounted, there is no way to
> distinguish between messages from different UBI devices.
> Add device number to all ubi layer message types.
> 
> 
> Signed-off-by: Tanya Brokhman <tlinder@codeaurora.org>
> 
> ---
>  drivers/mtd/ubi/attach.c  | 138 ++++++++++++++++++++----------------
>  drivers/mtd/ubi/build.c   | 130 ++++++++++++++++++++--------------
>  drivers/mtd/ubi/cdev.c    |  37 +++++-----
>  drivers/mtd/ubi/debug.c   |   9 +--
>  drivers/mtd/ubi/eba.c     |  54 +++++++-------
>  drivers/mtd/ubi/fastmap.c | 108 ++++++++++++++++------------
>  drivers/mtd/ubi/io.c      | 177 +++++++++++++++++++++++++++-------------------
>  drivers/mtd/ubi/kapi.c    |   6 +-
>  drivers/mtd/ubi/misc.c    |   6 +-
>  drivers/mtd/ubi/ubi.h     |  13 ++--
>  drivers/mtd/ubi/vmt.c     |  76 +++++++++++---------
>  drivers/mtd/ubi/vtbl.c    |  54 ++++++++------
>  drivers/mtd/ubi/wl.c      |  87 +++++++++++++++--------
>  13 files changed, 521 insertions(+), 374 deletions(-)

Compilation breaks while I try to compile with this patch.
May be you need to update remaining ubi layer messages also.

Thanks,
--Kiran

