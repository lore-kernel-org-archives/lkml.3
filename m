Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933986AbaD3QOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:14:04 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:37361 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933694AbaD3QOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:14:02 -0400
Date: Wed, 30 Apr 2014 18:13:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] kbuild: Use relative paths if possible
Message-ID: <20140430161358.GB15320@ravnborg.org>
References: <1398780493-15391-1-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398780493-15391-1-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 04:08:08PM +0200, Michal Marek wrote:
> Hi,
> 
> This series changes the Makefile to use relative paths for $(objtree),
> always setting it to '.', and for $(srctree) setting either to '.' or
> '..', when building in the source tree or a subdirectory thereof,
> respectively. The goal is to make compiler messages and Ooopses more
> readable by avoiding the full path to the source/object directory.
> 
> Patch 2/5 is just an unrelated cleanup.
> 
> Michal
> 
> Michal Marek (5):
>   firmware: Simplify directory creation
>   firmware: Use $(quote) in the Makefile
>   kbuild: Use relative path for $(objtree)
>   kbuild: Use relative path when building in the source tree
>   kbuild: Use relative path when building in a subdir of the source tree

For patch 2,3,4 and 5 you can add my:
Acked-by: Sam Ravnborg <sam@ravnborg.org>

Patch 1 also looks good, but I did not fully grasp it and this is MO
implied by an ack. So please do not hold it back due to this as
the cleanup looked good.

	Sam
