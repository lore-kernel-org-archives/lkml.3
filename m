Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaERSuS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 14:50:18 -0400
Received: from tex.lwn.net ([70.33.254.29]:52346 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbaERSuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 14:50:16 -0400
Date: Sun, 18 May 2014 12:51:32 -0600
From: Jake Edge <jake@lwn.net>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Cooper <jason@lakedaemon.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging/skein: rename files and clean up directory
 structure
Message-ID: <20140518125132.66cad23c@chukar.edge2.net>
In-Reply-To: <1400438573.21382.10.camel@joe-AO725>
References: <20140518123610.45c5469c@chukar.edge2.net>
	<1400438573.21382.10.camel@joe-AO725>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 May 2014 11:42:53 -0700 Joe Perches wrote:
> On Sun, 2014-05-18 at 12:36 -0600, Jake Edge wrote:
> > Clean up file names and locations.  Get rid of include/ directory
> > and move those up to the top-level.  Rename files to get rid of
> > upper case.  Remove skeinBlockNo3F.c as it was unused (temporary
> > file or something?).
> []
> > Diff appears to be huge because of the rearranging, not that much
> > to it, really ...
> 
> Hi Jake.
> 
> Please use "git format-patch -M" when renaming files.
> 
> This patch becomes simple and much more legible.

Ah, so it does, thank you!  I'll send a v2 here in a second ...

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
