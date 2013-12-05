Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab3LEGEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 01:04:49 -0500
Received: from cobra.newdream.net ([66.33.216.30]:43106 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab3LEGEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 01:04:44 -0500
Date: Wed, 4 Dec 2013 22:04:43 -0800 (PST)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: Li Wang <liwang@ubuntukylin.com>
cc: ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: Re: [PATCH 0/2] ceph: Add clean up if invalid osd reply received
In-Reply-To: <cover.1385561919.git.liwang@ubuntukylin.com>
Message-ID: <alpine.DEB.2.00.1312042204370.19900@cobra.newdream.net>
References: <cover.1385561919.git.liwang@ubuntukylin.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

APplied these both to teh testing branch.  Thanks!

On Wed, 27 Nov 2013, Li Wang wrote:

> Signed-off-by: Li Wang <liwang@ubuntukylin.com>
> Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
> 
> Li Wang (2):
>   ceph: Clean up if error occurred in finish_read()
>   ceph: Add necessary clean up if invalid reply received in
>     handle_reply()
> 
>  fs/ceph/addr.c        |    3 +++
>  net/ceph/osd_client.c |    7 +++++++
>  2 files changed, 10 insertions(+)
> 
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
