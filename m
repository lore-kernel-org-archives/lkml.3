Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888Ab3CVO6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:58:48 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:43619
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933680Ab3CVO6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:58:45 -0400
Date: Fri, 22 Mar 2013 08:58:35 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: asamymuthupa@micron.com, smani@micron.com, sbradshaw@micron.com,
        yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] mtip32xx: fix error return code in mtip_pci_probe()
Message-ID: <20130322145835.GH25978@kernel.dk>
References: <CAPgLHd81XvGLMBwfyBz6Rf6aVJhKXzqg_PGiujtob=re2EdKuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd81XvGLMBwfyBz6Rf6aVJhKXzqg_PGiujtob=re2EdKuw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20 2013, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return a negative error code from the error handling
> case instead of 0, as returned elsewhere in this function.

Good catch, applied!

-- 
Jens Axboe

