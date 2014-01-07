Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbaAGGDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 01:03:45 -0500
Received: from asavdk4.altibox.net ([109.247.116.15]:52577 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaAGGDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 01:03:43 -0500
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jan 2014 01:03:43 EST
Date: Tue, 7 Jan 2014 06:55:32 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Marek <mmarek@suse.cz>,
        Rashika Kheria <rashika.kheria@gmail.com>
Subject: Re: #pragma once?
Message-ID: <20140107055532.GA16581@ravnborg.org>
References: <20140106204706.GA16924@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140106204706.GA16924@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 12:47:07PM -0800, Josh Triplett wrote:
> [CCing build-system folks and others likely to know about potential
> issues.]
> 
> Does anyone have any objection to the use of "#pragma once" instead of
> the usual #ifndef-#define-...-#endif include guard?  GCC, LLVM/clang,
> and the latest Sparse all support either method just fine.  (I added
> support to Sparse myself.)  Both have equivalent performance.  "#pragma
> once" is simpler, and avoids the possibility of a typo in the defined
> guard symbol.
For kernel headers no concern.

For UAPI headers we should be more carefull - as we do not know which
compiler it ends up seeing - and what version.

	Sam
