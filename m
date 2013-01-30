Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab3A3Ram (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 12:30:42 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:50422 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab3A3Rak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 12:30:40 -0500
Date: Wed, 30 Jan 2013 12:29:57 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH] staging: zsmalloc: remove unused pool name
Message-ID: <20130130172956.GC2217@konrad-lan.dumpdata.com>
References: <1359560212-8818-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <51093F43.2090503@linux.vnet.ibm.com>
 <20130130172159.GA24760@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130130172159.GA24760@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 06:21:59PM +0100, Greg Kroah-Hartman wrote:
> On Wed, Jan 30, 2013 at 09:41:55AM -0600, Seth Jennings wrote:
> > On 01/30/2013 09:36 AM, Seth Jennings wrote:> zs_create_pool()
> > currently takes a name argument which is
> > > never used in any useful way.
> > >
> > > This patch removes it.
> > >
> > > Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> > 
> > Crud, forgot the Acks...
> > 
> > Acked-by: Nitin Gupta <ngupta@vflare.org>
> > Acked-by: Rik van Riel <riel@redhat.com>
> 
> {sigh} you just made me have to edit your patch by hand, you now owe me
> a beer...
> 
Should we codify that :-)


diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index c379a2a..f879c60 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -94,6 +94,7 @@ includes updates for subsystem X.  Please apply."
 The maintainer will thank you if you write your patch description in a
 form which can be easily pulled into Linux's source code management
 system, git, as a "commit log".  See #15, below.
+If the maintainer has to hand-edit your patch, you owe them a beer.
 
 If your description starts to get long, that's a sign that you probably
 need to split up your patch.  See #3, next.
