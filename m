Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab3GYRBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:01:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36467 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab3GYRB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:01:26 -0400
Date: Thu, 25 Jul 2013 10:01:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Won Kang <wkang77@gmail.com>
Cc: devel@driverdev.osuosl.org, wonkang@gctsemi.com,
        linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v2 1/2] staging: gdm7240: adding LTE USB driver
Message-ID: <20130725170125.GA4496@kroah.com>
References: <1374476192-7801-1-git-send-email-wonkang@gctsemi.com>
 <1374690977-10877-1-git-send-email-wonkang@gctsemi.com>
 <20130724215340.GY5585@mwanda>
 <20130724220631.GA10541@kroah.com>
 <CABe_0=+bXAuXhG+XG4ObUO_2MYD_XWxF_wbTVrpKagmHi8_CDQ@mail.gmail.com>
 <20130725043741.GA11906@kroah.com>
 <CABe_0=JCfq3pHvmQK42NQd16JRj-xjXP=jLvN5QCk-k8KH199w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABe_0=JCfq3pHvmQK42NQd16JRj-xjXP=jLvN5QCk-k8KH199w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 02:56:51PM +0900, Won Kang wrote:
> Anyway, you are right that endianess matters only when using this SDK.
> If you suggest to remove the ioctl because SDK is optional, I will
> agree.

Thanks, I've now removed it from the driver.

greg k-h
