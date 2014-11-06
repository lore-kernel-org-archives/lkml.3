Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305AbaKFO72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 09:59:28 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:37673 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaKFO70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 09:59:26 -0500
Date: Thu, 6 Nov 2014 17:58:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, hverkuil@xs4all.nl,
        ismael.luceno@corp.bluecherry.net, m.chehab@samsung.com
Subject: Re: [PATCH 1/4] [media] solo6x10: free vb2 buffers on stop_streaming
Message-ID: <20141106145849.GP6879@mwanda>
References: <1414598634-13446-1-git-send-email-andrey.krieger.utkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414598634-13446-1-git-send-email-andrey.krieger.utkin@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 08:03:51PM +0400, Andrey Utkin wrote:
> This fixes warning from drivers/media/v4l2-core/videobuf2-core.c:2144
> 

On my kernel that line is:

	q->start_streaming_called = 0;

This changelog is useless.

regards,
dan carpenter

