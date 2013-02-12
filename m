Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933682Ab3BLUCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:02:51 -0500
Received: from gate.crashing.org ([63.228.1.57]:60974 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932369Ab3BLUCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:02:49 -0500
Subject: Re: [PATCH -next] powerpc/85xx: use for_each_compatible_node() macro
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=iso-8859-1
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <CAPgLHd_esknTwVv4EeehwSJz6ee5eFJ+zf6xntH-vaNwdxkrvg@mail.gmail.com>
Date: Tue, 12 Feb 2013 14:02:01 -0600
Cc: benh@kernel.crashing.org, paulus@samba.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, yongjun_wei@trendmicro.com.cn,
        linuxppc-dev@lists.ozlabs.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <1C757F9C-FD71-44C5-B018-DF0F38571BC8@kernel.crashing.org>
References: <CAPgLHd_esknTwVv4EeehwSJz6ee5eFJ+zf6xntH-vaNwdxkrvg@mail.gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 3, 2012, at 7:36 AM, Wei Yongjun wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Use for_each_compatible_node() macro instead of open coding it.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
> arch/powerpc/platforms/85xx/mpc85xx_mds.c | 4 +---
> 1 file changed, 1 insertion(+), 3 deletions(-)

applied to next

- k
