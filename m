Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbbAGKJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 05:09:27 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:56457 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbbAGKJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 05:09:25 -0500
Date: Wed, 7 Jan 2015 10:09:10 +0000
From: Will Deacon <will.deacon@arm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 03/40] arm64/uaccess: fix sparse errors
Message-ID: <20150107100910.GA7485@arm.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
 <1420558883-10131-4-git-send-email-mst@redhat.com>
 <20150106191432.GC32449@arm.com>
 <20150106214820.GA18895@redhat.com>
 <20150106215115.GA21594@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106215115.GA21594@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 09:51:15PM +0000, Michael S. Tsirkin wrote:
> On Tue, Jan 06, 2015 at 11:48:20PM +0200, Michael S. Tsirkin wrote:
> > On Tue, Jan 06, 2015 at 07:14:32PM +0000, Will Deacon wrote:
> > > Hi Michael,
> > > 
> > > On Tue, Jan 06, 2015 at 03:43:40PM +0000, Michael S. Tsirkin wrote:
> > > > virtio wants to read bitwise types from userspace using get_user.  At the
> > > > moment this triggers sparse errors, since the value is passed through an
> > > > integer.
> > > > 
> > > > Fix that up using __force.
> > > > 
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > 
> > > > Acked-by: Will Deacon <will.deacon@arm.com>
> > > > ---
> > > 
> > > Did you want us to take this via the arm64 tree, or are you planning to
> > > merge it via another route?
> > > 
> > > Will
> > 
> > Up to you really: if you don't pick it up, Arnd said he'll merge
> > through his tree.
> 
> Though if you do pick it up, need to also pick up the follow-up
> patch - maybe my tree is easier.

Ok, I'll go ack that whitespace fix for you to take then.

Will
