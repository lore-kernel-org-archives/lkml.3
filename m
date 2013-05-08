Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab3EHA7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 20:59:23 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:49356 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab3EHA7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 20:59:22 -0400
X-AuditID: 9c93016f-b7ba0ae000004cc2-5f-5189a367c1e6
In-Reply-To: <1367914553-1999-1-git-send-email-chanho.min@lge.com>
References: <1367914553-1999-1-git-send-email-chanho.min@lge.com>
Subject: Re : Re: [PATCH RESEND v3] bitmap: speed up bitmap_find_free_region
X-Brightmail-Tracker: AAAAAA==
Reply-To: "Chanho Min" <chanho.min@lge.com>
X-Priority: 3 (Normal)
From: "Chanho Min" <chanho.min@lge.com>
To: anish singh <anish198519851985@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Message-ID: <OF9884F33D.464250EE-ON49257B65.00056B4D-49257B65.00056B4F@lge.com>
Date: Wed, 8 May 2013 09:59:11 +0900
X-MIMETrack: Serialize by Router on LGEKRHQMS17/LGE/LG Group(Release 6.5.5FP3HF116 | July
 11, 2008) at 2013/05/08 09:59:19
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Test case 1: order is 0. all bits are one except that last one bit is zero.
>>  before patch: 29727 ns
>>  after patch: 2349 ns
>How did you find out this time?Can  you please post your code
>for that?
I used local_clock(), But, It may be more proper way for each system.

 before = local_clock();
 bitmap_find_free_region(bitmap, 1024,0);
 after = local_clock();

Chanho Min,

