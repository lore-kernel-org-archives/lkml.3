Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbaKGGbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 01:31:10 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46741 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaKGGbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 01:31:07 -0500
Date: Fri, 7 Nov 2014 09:30:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, hverkuil@xs4all.nl, m.chehab@samsung.com
Subject: Re: [PATCH v2 1/4] [media] solo6x10: clean up properly in
 stop_streaming
Message-ID: <20141107063053.GC17639@mwanda>
References: <20141106145849.GP6879@mwanda>
 <1415307978-29665-1-git-send-email-andrey.krieger.utkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415307978-29665-1-git-send-email-andrey.krieger.utkin@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 01:06:18AM +0400, Andrey Utkin wrote:
> This fixes warning from drivers/media/v4l2-core/videobuf2-core.c,
> WARN_ON(atomic_read(&q->owned_by_drv_count)).
> 

Thanks!

regards,
dan carpenter


