Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaK3O6L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 09:58:11 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbaK3O6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 09:58:10 -0500
Message-ID: <547B3078.4020905@nod.at>
Date: Sun, 30 Nov 2014 15:58:00 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: Artem Bityutskiy <dedekind1@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] UBI: Add accessor functions for WL data structures
References: <1417349988-9238-1-git-send-email-richard@nod.at>	<1417349988-9238-3-git-send-email-richard@nod.at> <CAOMZO5BVewD==3dDLBD_AwrffMBih5EG3YYfYBAfH=+wDpV=3Q@mail.gmail.com>
In-Reply-To: <CAOMZO5BVewD==3dDLBD_AwrffMBih5EG3YYfYBAfH=+wDpV=3Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 30.11.2014 um 15:55 schrieb Fabio Estevam:
> On Sun, Nov 30, 2014 at 10:19 AM, Richard Weinberger <richard@nod.at> wrote:
> 
>> +/*
>> + * ubi_for_each_free_peb - walk the UBI free RB tree.
>> + * @ubi: UBI device description object
>> + * @e: a pointer to a ubi_wl_entry to use as cursor
>> + * @pos: a pointer to RB-tree entry type to use as a loop counter
> 
> tmp_rb instead?
> 
>> + */
>> +#define ubi_for_each_free_peb(ubi, e, tmp_rb)  \
>> +       ubi_rb_for_each_entry((tmp_rb), (e), &(ubi)->free, u.rb)
>> +
>> +/*
>> + * ubi_for_each_used_peb - walk the UBI used RB tree.
>> + * @ubi: UBI device description object
>> + * @e: a pointer to a ubi_wl_entry to use as cursor
>> + * @pos: a pointer to RB-tree entry type to use as a loop counter
>> + */
> 
> tmp_rb instead?

Correct. I need a generator script for such stuff. :)

Thanks,
//richard
