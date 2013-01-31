Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab3AaFan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 00:30:43 -0500
Received: from mail.kernel.org ([198.145.19.201]:50700 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524Ab3AaFak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 00:30:40 -0500
Date: Thu, 31 Jan 2013 06:32:35 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH] staging: zsmalloc: remove unused pool name
Message-ID: <20130131053235.GD3228@kroah.com>
References: <1359560212-8818-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <51093F43.2090503@linux.vnet.ibm.com>
 <20130130172159.GA24760@kroah.com>
 <20130130172956.GC2217@konrad-lan.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130130172956.GC2217@konrad-lan.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 12:29:57PM -0500, Konrad Rzeszutek Wilk wrote:
> On Wed, Jan 30, 2013 at 06:21:59PM +0100, Greg Kroah-Hartman wrote:
> > On Wed, Jan 30, 2013 at 09:41:55AM -0600, Seth Jennings wrote:
> > > On 01/30/2013 09:36 AM, Seth Jennings wrote:> zs_create_pool()
> > > currently takes a name argument which is
> > > > never used in any useful way.
> > > >
> > > > This patch removes it.
> > > >
> > > > Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> > > 
> > > Crud, forgot the Acks...
> > > 
> > > Acked-by: Nitin Gupta <ngupta@vflare.org>
> > > Acked-by: Rik van Riel <riel@redhat.com>
> > 
> > {sigh} you just made me have to edit your patch by hand, you now owe me
> > a beer...
> > 
> Should we codify that :-)
> 
> 
> diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
> index c379a2a..f879c60 100644
> --- a/Documentation/SubmittingPatches
> +++ b/Documentation/SubmittingPatches
> @@ -94,6 +94,7 @@ includes updates for subsystem X.  Please apply."
>  The maintainer will thank you if you write your patch description in a
>  form which can be easily pulled into Linux's source code management
>  system, git, as a "commit log".  See #15, below.
> +If the maintainer has to hand-edit your patch, you owe them a beer.
>  
>  If your description starts to get long, that's a sign that you probably
>  need to split up your patch.  See #3, next.

Yes we do need to codify this, but let's be fair, not everyone likes
beer:

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index c379a2a..d1bec01 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -93,7 +93,9 @@ includes updates for subsystem X.  Please apply."
 
 The maintainer will thank you if you write your patch description in a
 form which can be easily pulled into Linux's source code management
-system, git, as a "commit log".  See #15, below.
+system, git, as a "commit log".  See #15, below.  If the maintainer has
+to hand-edit your patch, you owe them the beverage of their choice the
+next time you see them.
 
 If your description starts to get long, that's a sign that you probably
 need to split up your patch.  See #3, next.
