Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbaGHPUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 11:20:25 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17402 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaGHPUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 11:20:23 -0400
Date: Tue, 8 Jul 2014 18:20:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-media@vger.kernel.org, gregkh@linuxfoundation.org,
        ismael.luceno@corp.bluecherry.net, m.chehab@samsung.com
Subject: Re: [PATCH 1/2] solo6x10: expose encoder quantization setting as
 V4L2 control
Message-ID: <20140708152009.GR25880@mwanda>
References: <1404829834-8747-1-git-send-email-andrey.utkin@corp.bluecherry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404829834-8747-1-git-send-email-andrey.utkin@corp.bluecherry.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 05:30:33PM +0300, Andrey Utkin wrote:
> solo6*10 boards have configurable quantization parameter which takes
> values from 0 to 31, inclusively.
> 
> This change enables setting it with ioctl VIDIOC_S_CTRL with id
> V4L2_CID_MPEG_VIDEO_H264_MIN_QP.

Both of these two need signed-off-by lines.

regards,
dan carpenter

