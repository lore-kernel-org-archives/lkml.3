Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbaHRM5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 08:57:41 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20692 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaHRM5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 08:57:40 -0400
Date: Mon, 18 Aug 2014 15:57:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@google.com>
Subject: Re: [PATCH 1/2] android: fix reference leak in sync_fence_create
Message-ID: <20140818125719.GA5423@mwanda>
References: <53EC8722.4070407@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EC8722.4070407@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 11:53:38AM +0200, Maarten Lankhorst wrote:
> According to the documentation sync_fence_create takes ownership of the point,
> not a reference on the point.
> 

What are the user visible effects of this bug?  I assume this is a real
bug but judging solely based on your patch description, it sounds like
you could just update the documentation instead of changing the code.

regards,
dan carpenter

