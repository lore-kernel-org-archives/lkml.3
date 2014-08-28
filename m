Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaH1L6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 07:58:14 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20746 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaH1L6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 07:58:11 -0400
Date: Thu, 28 Aug 2014 14:57:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        LKML <linux-kernel@vger.kernel.org>, Colin Cross <ccross@google.com>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH 2/2] android: add sync_fence_create_dma
Message-ID: <20140828115747.GL5046@mwanda>
References: <53EC8722.4070407@canonical.com>
 <53EC876C.9050705@canonical.com>
 <20140815064656.GB20920@kroah.com>
 <53FED20D.3030506@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FED20D.3030506@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 08:54:05AM +0200, Maarten Lankhorst wrote:
> Hey,
> 
> On 15-08-14 08:46, Greg Kroah-Hartman wrote:
> > On Thu, Aug 14, 2014 at 11:54:52AM +0200, Maarten Lankhorst wrote:
> >> This allows users of dma fences to create a android fence.
> > 
> > Who is going to use these functions?  I need an in-kernel user before I
> > can add new api calls.
> 
> So I found a in-kernel user and PATCH 1/2 fixes a mem-leak with android out of tree drivers, and android's in-kernel sw-sync.
> Will you apply these patches?

Can you resend the patches?  Fix the changelog of the first one to
mention that it is a bugfix.  Send a [patch 3/3] which uses the new
functions in [patch 2/3].

regards,
dan carpenter

