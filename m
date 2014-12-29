Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbaL2Ct4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 21:49:56 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40323 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaL2Cty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 21:49:54 -0500
Date: Mon, 29 Dec 2014 02:49:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: overlayfs: Fix coding style issues, missing a blank
 line after declarations
Message-ID: <20141229024951.GA9934@ZenIV.linux.org.uk>
References: <1419746213-5405-1-git-send-email-kuleshovmail@gmail.com>
 <20141229023939.GL22149@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141229023939.GL22149@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 02:39:39AM +0000, Al Viro wrote:
> On Sun, Dec 28, 2014 at 11:56:53AM +0600, Alexander Kuleshov wrote:
> > Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
> > ---
> 
> For the record: anything of that sort against fs/*.c will be flushed down
> the toilet where such valuable contributions belong.  Don't even bother.

Joe, could you please explain what has driven you to include that into
scripts/checkpatch.pl and open the countless sphincters?  Aren't we
getting enough pointless patches as it is?

Al, stongly tempted to try and sneak a patch to checkpatch.pl declaring the
lack of /* See Figure 1 */ within the first 10 lines of a function an offense
against the Gods Of Style.  Then sit back and watch the resulting spew...
