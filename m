Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934943Ab3IDPRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 11:17:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40227 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603Ab3IDPRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 11:17:10 -0400
Date: Wed, 4 Sep 2013 08:17:08 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: rwheeler@redhat.com, avati@redhat.com, viro@ZenIV.linux.org.uk,
        bfoster@redhat.com, dhowells@redhat.com, eparis@redhat.com,
        raven@themaw.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mszeredi@suse.cz
Subject: Re: [PATCH 07/10] sysfs: use check_submounts_and_drop()
Message-ID: <20130904151708.GA28775@kroah.com>
References: <1378303556-7220-1-git-send-email-miklos@szeredi.hu>
 <1378303556-7220-8-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378303556-7220-8-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 04:05:53PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Do have_submounts(), shrink_dcache_parent() and d_drop() atomically.
> 
> check_submounts_and_drop() can deal with negative dentries and
> non-directories as well.
> 
> Non-directories can also be mounted on.  And just like directories we don't
> want these to disappear with invalidation.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
