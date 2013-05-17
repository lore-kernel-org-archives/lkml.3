Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab3EQJls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 05:41:48 -0400
Received: from sauhun.de ([89.238.76.85]:47066 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab3EQJlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 05:41:47 -0400
Date: Fri, 17 May 2013 11:43:04 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Libo Chen <libo.chen@huawei.com>
Cc: Sonic.Zhang@analog.com, uclinux-dist-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        lizefan@huawei.com
Subject: Re: [PATCH v2 0/2] i2c: fix two wrong mem release
Message-ID: <20130517094301.GH17056@katana>
References: <1368088044-20408-1-git-send-email-libo.chen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368088044-20408-1-git-send-email-libo.chen@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 04:27:22PM +0800, Libo Chen wrote:
> fix two wrong mem release
> 
> * Changelog from v1:
>   * exchange out_error_no_irq and out_error_pin_mux  suggested by Sonic <Sonic.Zhang@analog.com>  
>   * add some new tag , make code cleanly

Thanks for the submission. I do think the proper solution would be to
convert the drivers to use the devm_* mechanisms, though. You can check
commit 857968434bb6dbda0911f38ec46b0c3d0c963771 ("i2c: davinci: update
to devm_* API") as a reference.

Thanks,

   Wolfram
