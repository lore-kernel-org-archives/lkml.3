Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbaJIQnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 12:43:50 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65276 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbaJIQnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:43:41 -0400
Message-ID: <5436BB39.8030907@nod.at>
Date: Thu, 09 Oct 2014 18:43:37 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Wei Wang <wangw8210@gmail.com>, linux-mtd@lists.infradead.org
CC: dedeking1@gmail.com, linux-arm-msm@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: Questions about MTD + flash file system
References: <CAF-d49R64tbzk_2QnX3uwMc2LnpyzKmdfmY2D4P1=r+_DMi0fg@mail.gmail.com>
In-Reply-To: <CAF-d49R64tbzk_2QnX3uwMc2LnpyzKmdfmY2D4P1=r+_DMi0fg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.10.2014 18:40, schrieb Wei Wang:
> Hi all,
> 
> I have a question about the MTD device for embedded applications. As typically designers are more likely to use an eMMC or block interface-based flash devices + a block-oriented
> file system for the storage system on an embedded system, what's the typical use case for the MTD + flash file system? What's the advantage of the later one against eMMC +
> block-oriented file system?
> 
> If an eMMC becomes more powerful, is there any merits that is provided by using an raw flash device + flash file system?

Power cut resistance.

Thanks,
//richard


