Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab3HWEId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 00:08:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab3HWEIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 00:08:31 -0400
Date: Thu, 22 Aug 2013 21:10:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rui Xiang <rui.xiang@huawei.com>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-usb@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, linux-mm@kvack.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] fs: supply inode uid/gid setting interface
Message-ID: <20130823041010.GA12296@kroah.com>
References: <1377226118-43756-1-git-send-email-rui.xiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377226118-43756-1-git-send-email-rui.xiang@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 10:48:36AM +0800, Rui Xiang wrote:
> This patchset implements an accessor functions to set uid/gid
> in inode struct. Just finish code clean up.

Why?
