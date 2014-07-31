Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315AbaGaIZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 04:25:43 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42691 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073AbaGaIZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 04:25:41 -0400
Date: Thu, 31 Jul 2014 11:25:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, joe@perches.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] Staging: android: timed_gpio.c: improved logic of
 gpio_get_time()
Message-ID: <20140731082521.GM4856@mwanda>
References: <1406610143.5285.14.camel@joe-AO725>
 <1406764040-31729-1-git-send-email-mopsfelder@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406764040-31729-1-git-send-email-mopsfelder@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 08:47:19PM -0300, Murilo Opsfelder Araujo wrote:
> Thanks for reviewing my first patch, Joe.  How about this new one,
> guys?
> 
> -- >8 --
> Consequently, made checkpatch.pl happy.
> 
> Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>

This changelog is all mangled.  Try applying it with `git am`.  It
doesn't make sense to begin with.  What consequently?

regards,
dan carpenter

