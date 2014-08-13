Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbaHMV6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 17:58:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51035 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaHMV6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 17:58:20 -0400
Date: Thu, 14 Aug 2014 05:57:42 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Matt Longnecker <mlongnecker@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mattias.nissler@gmx.de
Subject: Re: debugfs_create_{u,x,s}{8,16,32,64}
Message-ID: <20140813215742.GA7908@kroah.com>
References: <53EBDF31.7010204@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EBDF31.7010204@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 02:57:05PM -0700, Matt Longnecker wrote:
> Greg,
> 
> Back in December 2007 Mattias Nissler proposed a patch defining
> debugfs_create_s32 and friends. In it he reworked the already existent u and
> x versions. The subject of Mattias's mail was "[PATCH] debugfs: Revamp
> debugfs_create_{u,x,s}{8,16,32,64} to support signed integers".
> 
> As I'm writing a new driver related to thermal management, I'm finding the
> absence of debugfs_create_s32 to be a stumbling block. I see at least two
> other folks who have stumbled on the absence of debugfs_create_s32 in the
> past few years.
> 
> Why didn't we merge Mattias's patch?

I can't remember why I didn't merge a patch from last week, let alone
from 2007, are you crazy?  :)

> Would you entertain a similar patch today?

I always entertain all patches, you never need to ask if you are allowed
to send a patch, that's like asking "Am I allowed to ask a question?"...

greg k-h
