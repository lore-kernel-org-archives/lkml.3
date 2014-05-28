Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaE1MKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 08:10:43 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:50264 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbaE1MKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 08:10:41 -0400
Date: Wed, 28 May 2014 22:09:33 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Christoph Hellwig <hch@infradead.org>
cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH 05/12] scsi/NCR5380: fix build failures when debugging
 is enabled
In-Reply-To: <20140528095015.GE26617@infradead.org>
Message-ID: <alpine.LNX.2.00.1405282207580.31798@nippy.intranet>
References: <20140318004212.612472697@telegraphics.com.au> <20140318004214.102469994@telegraphics.com.au> <20140528095015.GE26617@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 28 May 2014, Christoph Hellwig wrote:

> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

Thanks for reviewing. There was a later submission (version 2) with 
changes made to three of these patches,

[PATCH v2 05/12] scsi/NCR5380: fix build failures when debugging is enabled
[PATCH v2 06/12] scsi/NCR5380: fix dprintk macro usage and definition
[PATCH v2 09/12] scsi/NCR5380: fix and standardize NDEBUG macros

And several patches in the v2 submission had some acked-by tags added.

The v2 series is the one to merge (but I think James intends to do that).

-- 
