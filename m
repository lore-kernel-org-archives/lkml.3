Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab3H0XiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 19:38:06 -0400
Received: from cobra.newdream.net ([66.33.216.30]:55843 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab3H0XiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 19:38:04 -0400
Date: Tue, 27 Aug 2013 16:38:04 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: Andrew Morton <akpm@linux-foundation.org>
cc: Li Wang <liwang@ubuntukylin.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: Re: [PATCH v5] Ceph: Punch hole support for kernel client
In-Reply-To: <20130827163555.99ef8be3dacd5bd5eadcac8c@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1308271637280.24783@cobra.newdream.net>
References: <1376538704-6659-1-git-send-email-liwang@ubuntukylin.com> <20130827163555.99ef8be3dacd5bd5eadcac8c@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Aug 2013, Andrew Morton wrote:
> On Thu, 15 Aug 2013 11:51:44 +0800 Li Wang <liwang@ubuntukylin.com> wrote:
> 
> > This patch implements fallocate and punch hole support for Ceph kernel client.
> 
> i386 allmodconfig:
> 
> ERROR: "__divdi3" [fs/ceph/ceph.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> 
> Due to a 64-bit divide in ceph_zero_objects()

Yep, fix is in the ceph-client.git master branch now and should get picked 
up by the next -next.

sage
