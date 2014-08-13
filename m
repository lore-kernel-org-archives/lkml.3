Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbaHMMac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 08:30:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44862 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaHMMab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 08:30:31 -0400
Date: Wed, 13 Aug 2014 13:30:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: shivnandan.k@samsung.com
Cc: sds@tycho.nsa.gov, james.l.morris@oracle.com, eparis@parisplace.org,
        selinux@tycho.nsa.gov, cpgs@samsung.com, ashish.kalra@samsung.com,
        mohammad.a2@samsung.com, rajat.suri@samsung.com,
        shiv.jnumca08@gmail.com, linux-kernel@vger.kernel.org,
        vidushi.koul@samsung.com, narendra.m1@samsung.com
Subject: Re: [PATCH] Security: List corruption occured during file system
 automation test
Message-ID: <20140813123021.GX18016@ZenIV.linux.org.uk>
References: <1407929653-27228-1-git-send-email-shivnandan.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407929653-27228-1-git-send-email-shivnandan.k@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 05:04:13PM +0530, shivnandan.k@samsung.com wrote:
> From: Shivnandan Kumar <shivnandan.k@samsung.com>
> 
> List element was freed by  inode_free_security and then it uses rcu
> element to point inode_free_rcu, since it inside a union so it
> shares memory, sb_finish_set_opts now also try to free list element,

How in hell does it find that element?
