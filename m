Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaGHXd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:33:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37920 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaGHXd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:33:56 -0400
Date: Tue, 8 Jul 2014 16:38:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: devel@driverdev.osuosl.org, shaun@XResource.ca, weo@weo1.de,
        sachin.kamat@linaro.org, linux-kernel@vger.kernel.org,
        himangi774@gmail.com, fempsci@gmail.com
Subject: Re: [PATCH 1/3 V2] staging: cxt1e1: Remove useless OS_phystov() and
 OS_vtophys()
Message-ID: <20140708233821.GA18798@kroah.com>
References: <20140630065611.GA28940@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630065611.GA28940@devel.8.8.4.4>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 03:56:11PM +0900, Daeseok Youn wrote:
> OS_phystov()/OS_vtophys() are replaced with
> phys_to_virt()/virt_to_phys().
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
> V2: use virt_to_phys()/phys_to_virt() instead of __pa()/__va().
> 
>  drivers/staging/cxt1e1/musycc.c              |   16 ++++++++--------
>  drivers/staging/cxt1e1/pmcc4_drv.c           |   12 ++++++------
>  drivers/staging/cxt1e1/sbecom_inline_linux.h |   19 -------------------
>  3 files changed, 14 insertions(+), 33 deletions(-)

This driver has been deleted from the tree, so the patches do not apply
:(

