Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbaDKBtD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 21:49:03 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:59134 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbaDKBtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 21:49:00 -0400
Date: Thu, 10 Apr 2014 18:48:58 -0700
From: Olof Johansson <olof@lixom.net>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org, hyunhee.kim@samsung.com,
        sw0312.kim@samsung.com, linux-kernel@vger.kernel.org,
        yj44.cho@samsung.com, inki.dae@samsung.com, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 03/27] ARM: EXYNOS: Add IO mapping for PMU of Exynos3250
Message-ID: <20140411014858.GC14934@quad.lixom.net>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
 <1397122658-16013-4-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397122658-16013-4-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 06:37:14PM +0900, Chanwoo Choi wrote:
> This patch add memory mapping for PMU (Power Management Unit) which is used
> for power control of Exynos3250.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Signed-off-by is in the wrong order, if Kyungmin wrote the patch and you're
just posting it...


-Olof
