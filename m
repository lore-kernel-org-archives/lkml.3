Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab3HKDDM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 23:03:12 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33166 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab3HKDDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 23:03:11 -0400
Message-ID: <5207A8C7.4050101@gmail.com>
Date: Sun, 11 Aug 2013 11:07:51 -0400
From: Huang Shijie <shijie8@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110817 Fedora/3.1.12-1.fc14 Thunderbird/3.1.12
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: Huang Shijie <b32955@freescale.com>, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org, dedekind1@gmail.com
Subject: Re: [PATCH v2 4/4] mtd: gpmi: update the ecc step size for mtd_info{}
References: <1368607606-4344-1-git-send-email-b32955@freescale.com> <1368607606-4344-5-git-send-email-b32955@freescale.com> <20130810074156.GB3467@norris.computersforpeace.net> <CAN8TOE8NhcYBP_x26=KC2yBUSS3xzVjMg+PHnxNNRNJWWLeSeg@mail.gmail.com>
In-Reply-To: <CAN8TOE8NhcYBP_x26=KC2yBUSS3xzVjMg+PHnxNNRNJWWLeSeg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年08月10日 03:53, Brian Norris 写道:
> The right way seems to be to avoid nand_scan() directly but instead to
> >  use nand_scan_ident() and nand_scan_tail() separately (that's what
> >  they're exported for) so that you can initialize any geometry-related
> >  options before nand_scan_tail() does the last steps.
i agree with you.
I will create a v3 version tomorrow when i back to office.

thanks for the review.
Huang Shijie
