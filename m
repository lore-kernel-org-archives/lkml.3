Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbaD1Mki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 08:40:38 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21992 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbaD1Mkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 08:40:36 -0400
Date: Mon, 28 Apr 2014 15:40:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: micky <micky_ching@realsil.com.cn>
Cc: chris@printf.net, sameo@linux.intel.com, ulf.hansson@linaro.org,
        gregkh@linuxfoundation.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei_wang@realsil.com.cn,
        rogerable@realtek.com, devel@linuxdriverproject.org
Subject: Re: [PATCH v2 2/2] mmc: rtsx: modify error handle and remove
 smatchwarnings
Message-ID: <20140428124001.GV26890@mwanda>
References: <cover.1395824147.git.micky_ching@realsil.com.cn>
 <2f71c814a30f26a0550f1132bd53a682338c44d3.1395824147.git.micky_ching@realsil.com.cn>
 <535E3D8D.3000309@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535E3D8D.3000309@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 07:37:49PM +0800, micky wrote:
> Hi Chris and Ulf,
> 
> This patch is denpend on commit c42deffd5b53c9e583d83c7964854ede2f12410d.
> <mmc: rtsx: add support for pre_req and post_req>, and we discard
> the previous commit.
> we want discard this patch also(it it now in linux-next), need I
> send another patch to
> revert or it will be discard automatically?

Send a patch to revert this patch as well.  You should have sent both
at the same time so it didn't cause breakage...

regards,
dan carpenter

