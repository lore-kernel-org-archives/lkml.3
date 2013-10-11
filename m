Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab3JKVT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 17:19:56 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:49270 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304Ab3JKVTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 17:19:55 -0400
Date: Fri, 11 Oct 2013 14:19:51 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: dwmw2@infradead.org, artem.bityutskiy@linux.intel.com, jg1.han@samsung.com,
        dan.carpenter@oracle.com, robert.jarzmik@free.fr,
        yongjun_wei@trendmicro.com.cn, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtg: docg3: use free_bch() instead of kfree()
Message-ID: <20131011211951.GP23337@ld-irv-0074.broadcom.com>
References: <CAPgLHd_vT4cJ1F1a6TDzYb2LFSb-me90K58K22Z=ae3VsOfbng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd_vT4cJ1F1a6TDzYb2LFSb-me90K58K22Z=ae3VsOfbng@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 12:40:21PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Use free_bch() instead of kfree() to free init_bch()
> allocated data.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Pushed to l2-mtd.git. Thanks!

Brian
