Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3DKTlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 15:41:01 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:35617 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab3DKTk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 15:40:59 -0400
Date: Thu, 11 Apr 2013 12:40:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, Dave Airlie <airlied@redhat.com>,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, kbuild@01.org
Subject: Re: [patch 1/2 -next] dma-buf: double unlock in debugfs code
Message-ID: <20130411194057.GA7193@kroah.com>
References: <20130411062339.GA7603@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411062339.GA7603@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 09:23:39AM +0300, Dan Carpenter wrote:
> We unlock here when we failed to take the lock.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This is in linux-next, and I think the debugfs code is only in Sumit's
> tree.

Yes, it's not in mine, so I can't take this, sorry.  Sumit, please apply
this:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
