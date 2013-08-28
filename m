Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab3H1FGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 01:06:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab3H1FGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 01:06:37 -0400
Date: Tue, 27 Aug 2013 22:08:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] debugfs: provide debugfs_create_x64() when disabled
Message-ID: <20130828050857.GA17192@kroah.com>
References: <1377503910-6919-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377503910-6919-1-git-send-email-johannes@sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 09:58:30AM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> commit 15b0beaa332b3923cc ("Add x64 support to debugfs") added
> debugfs_create_x64(), but forgot to provide it when debugfs is
> disabled, causing problems when code tries to use it even then.
> Provide the appropriate static inline.

That's funny, given that it's been this way for over 3 years without
anyone noticing :)

I'll go apply this, thanks.

greg k-h
