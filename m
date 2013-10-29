Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab3J2AoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 20:44:13 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:64936 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874Ab3J2AoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 20:44:12 -0400
X-AuditID: 9c93017e-b7ca6ae000000e8a-bb-526f04dac2a5
Date: Tue, 29 Oct 2013 09:44:14 +0900
From: Minchan Kim <minchan@kernel.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: opw-kernel@googlegroups.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/3] Staging: zram: Fix variable dereferenced before
 check
Message-ID: <20131029004414.GC17038@bbox>
References: <cc16130b4e23207971139eff313a4ec71f51c187.1382962788.git.rashika.kheria@gmail.com>
 <01cafd6f9a98d41c243ae507ae731edc5cca045a.1382962788.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01cafd6f9a98d41c243ae507ae731edc5cca045a.1382962788.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 05:53:40PM +0530, Rashika Kheria wrote:
> This patch fixes the following Smatch warning in zram_drv.c-
> drivers/staging/zram/zram_drv.c:899
> destroy_device() warn: variable dereferenced before check 'zram->disk' (see line 896)
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
