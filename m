Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117AbaFQO0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:26:46 -0400
Received: from p02c12o148.mxlogic.net ([208.65.145.81]:37666 "EHLO
	p02c12o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696AbaFQO0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:26:45 -0400
X-MXL-Hash: 53a05025215dcb03-4417845e0b54169a8d0c3bbbe9b5d6640111f5e6
X-MXL-Hash: 53a04fec49b0d205-e299f541e19ba558616ada187c27c038d701c029
Date: Tue, 17 Jun 2014 10:25:37 -0400
From: Joe Lawrence <joe.lawrence@stratus.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Jeff Moyer <jmoyer@redhat.com>, <linux-kernel@vger.kernel.org>,
        "Jens Axboe" <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] block,scsi: convert and handle ERR_PTR from
 blk_get_request
Message-ID: <20140617102537.550c8275@jlaw-desktop.mno.stratus.com>
In-Reply-To: <20140617103323.GA13101@infradead.org>
References: <1401396529-17275-1-git-send-email-joe.lawrence@stratus.com>
	<1401396529-17275-3-git-send-email-joe.lawrence@stratus.com>
	<x49mwdtvjtm.fsf@segfault.boston.devel.redhat.com>
	<20140603172646.769e90d6@jlaw-desktop.mno.stratus.com>
	<x498upcpn09.fsf@segfault.boston.devel.redhat.com>
	<20140617103323.GA13101@infradead.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-AnalysisOut: [v=2.1 cv=f8nGBYCM c=1 sm=1 tr=0 a=VNTQBUOG7PJoPU2GWtE7Ww==]
X-AnalysisOut: [:117 a=VNTQBUOG7PJoPU2GWtE7Ww==:17 a=87FPt2tEqakA:10 a=_KQ]
X-AnalysisOut: [qW7t0BisA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10 a=uelBKuK]
X-AnalysisOut: [pAAAA:8 a=YlVTAMxIAAAA:8 a=JfrnYn6hAAAA:8 a=D19gQVrFAAAA:8]
X-AnalysisOut: [ a=u7dBUldRdr2WpszQruwA:9 a=CjuIK1q_8ugA:10 a=JZBxSqCIBzwA]
X-AnalysisOut: [:10 a=3Rfx1nUSh_UA:10]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014061710); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2014 03:33:23 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, Jun 04, 2014 at 02:07:02PM -0400, Jeff Moyer wrote:
> > Wow, that's a lot more churn than I expected.  ;-) I think you should go
> > ahead and repost this patch with the change mentioned above (you can add
> > my reviewed-by), and we can revisit this scsi one separately if people
> > are interested.
> 
> Joe, did you manage to get back to this?

Hi Christoph,

v2 was posted with input from Jeff:

https://lkml.org/lkml/2014/6/4/482

-- Joe
