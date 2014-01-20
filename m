Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaATTjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 14:39:32 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:49209 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaATTjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 14:39:25 -0500
Date: Mon, 20 Jan 2014 11:39:21 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Wei Yongjun'" <weiyj.lk@gmail.com>,
        "'Wan ZongShun'" <mcuos.com@gmail.com>,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] mtd: nuc900_nand: remove redundant return value
 check of platform_get_resource()
Message-ID: <20140120193921.GR8919@ld-irv-0074>
References: <CAPgLHd_RMOPLP2f4nA1vqNNddocMUX7f-gE29TTkuJZPUm=SWw@mail.gmail.com>
 <001401cf0c04$691d63d0$3b582b70$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001401cf0c04$691d63d0$3b582b70$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 08:58:49AM +0900, Jingoo Han wrote:
> On Tuesday, January 07, 2014 10:39 PM, Wei Yongjun wrote:
> > 
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > 
> > Remove unneeded error handling on the result of a call
> > to platform_get_resource() when the value is passed to
> > devm_ioremap_resource().
> > 
> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Pushed to l2-mtd.git. Thanks!

Brian
