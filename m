Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750866AbaDKEAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 00:00:52 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:57387 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaDKEAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 00:00:50 -0400
Date: Thu, 10 Apr 2014 21:00:50 -0700
From: Olof Johansson <olof@lixom.net>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com, hyunhee.kim@samsung.com,
        yj44.cho@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 12/27] ARM: dts: exynos3250: Add default interrupt-parent
 connected with GIC
Message-ID: <20140411040050.GD14934@quad.lixom.net>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
 <1397124377-16969-4-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397124377-16969-4-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 07:06:02PM +0900, Chanwoo Choi wrote:
> This patch add interrupt-parent node to connected with GIC.
> All interrupt-related dt nodes need default interrupt-parent node.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

There's no point in splitting these off in separate patches; fold them
into one patch that introduces the SoC dtsi, please.

Also, you missed your sign-off on one or two of the previous ones, but that
won't be a problem once they're folded in. :)

Finally, if the code is yours, and you're posting it, then Kyungmin should
probably have a Reviewed-by or Acked-by tag, not a Signed-off-by. See
Documentation/SubmittingPatches, section 12 and 13.

-Olof
