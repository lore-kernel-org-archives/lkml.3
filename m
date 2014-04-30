Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422726AbaD3QML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:12:11 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:41763 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422657AbaD3QMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:12:09 -0400
Date: Wed, 30 Apr 2014 18:12:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 1/5] firmware: Simplify directory creation
Message-ID: <20140430161204.GA15320@ravnborg.org>
References: <1398780493-15391-1-git-send-email-mmarek@suse.cz>
 <1398780493-15391-2-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398780493-15391-2-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 04:08:09PM +0200, Michal Marek wrote:
> When building the firmware blobs, use a simple loop to create
> directories in $(objtree), like in Makefile.build. This simplifies the
> rules and also makes it possible to set $(objtree) to '.' later. Before
> this change, a dependency on $(objtree)/<dir> would be satisfied by
> <dir> in $(srctree).
> 
> When installing the firmware blobs, call mkdir like in Makefile.modinst.
> 
> Cc: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Michal Marek <mmarek@suse.cz>

Hi Michal.

The patch looks good. I di not stare enough to fully grasp it,
but it is a nice cleanup.

	Sam
