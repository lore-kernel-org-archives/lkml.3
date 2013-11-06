Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab3KFIhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 03:37:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33271 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab3KFIhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 03:37:48 -0500
Date: Wed, 6 Nov 2013 09:37:45 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ben Harris <bjh21@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, 726655@bugs.debian.org
Subject: Re: [PATCH] floppy: Correct documentation of driver options when
 used as a module.
In-Reply-To: <alpine.DEB.2.02.1310182117100.1531@puff.ds.cam.ac.uk>
Message-ID: <alpine.LNX.2.00.1311060937380.835@pobox.suse.cz>
References: <alpine.DEB.2.02.1310182117100.1531@puff.ds.cam.ac.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Oct 2013, Ben Harris wrote:

> From: Ben Harris <bjh21@cam.ac.uk>
> 
> The options have to be passed space-separated and prefixed by "floppy=",
> rather than separately and unprefixed.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
