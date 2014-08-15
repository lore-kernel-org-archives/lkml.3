Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbaHOP0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 11:26:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40580 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaHOP0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 11:26:44 -0400
Date: Fri, 15 Aug 2014 14:46:56 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Colin Cross <ccross@google.com>, John Stultz <john.stultz@linaro.org>,
        devel@driverdev.osuosl.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 2/2] android: add sync_fence_create_dma
Message-ID: <20140815064656.GB20920@kroah.com>
References: <53EC8722.4070407@canonical.com>
 <53EC876C.9050705@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EC876C.9050705@canonical.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 11:54:52AM +0200, Maarten Lankhorst wrote:
> This allows users of dma fences to create a android fence.

Who is going to use these functions?  I need an in-kernel user before I
can add new api calls.

thanks,

greg k-h
