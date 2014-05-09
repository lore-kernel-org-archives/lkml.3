Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbaEIQwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 12:52:25 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:40396 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271AbaEIQwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 12:52:23 -0400
Date: Fri, 9 May 2014 18:51:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v2 1/5] firmware: Simplify directory creation
Message-ID: <20140509165158.GA9486@ravnborg.org>
References: <1399639944-20551-1-git-send-email-mmarek@suse.cz>
 <1399639944-20551-2-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399639944-20551-2-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 02:52:20PM +0200, Michal Marek wrote:
> When building the firmware blobs, use a simple loop to create
> directories in $(objtree), like in Makefile.build. This simplifies the
> rules and also makes it possible to set $(objtree) to '.' later. Before
> this change, a dependency on $(objtree)/<dir> would be satisfied by
> <dir> in $(srctree).
> 
> When installing the firmware blobs, call mkdir like in Makefile.modinst.
> 
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
Looks good!
This time I spent a little time to actually look through the code - and it
end up being much simpler than before.

Acked-by: Sam Ravnborg <sam@ravnborg.org>


	Sam
