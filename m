Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbbAWQfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:35:13 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:42040 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbbAWQfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:35:10 -0500
Date: Fri, 23 Jan 2015 16:35:01 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Christopher Covington <cov@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH repost 03/16] arm64/uaccess: fix sparse errors
Message-ID: <20150123163500.GE9557@e104818-lin.cambridge.arm.com>
References: <1419499661-8566-1-git-send-email-mst@redhat.com>
 <1419499661-8566-4-git-send-email-mst@redhat.com>
 <20150123153316.GB9557@e104818-lin.cambridge.arm.com>
 <20150123154213.GB31460@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123154213.GB31460@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 03:42:14PM +0000, Will Deacon wrote:
> On Fri, Jan 23, 2015 at 03:33:16PM +0000, Catalin Marinas wrote:
> > On Thu, Dec 25, 2014 at 09:28:41AM +0000, Michael S. Tsirkin wrote:
> > > virtio wants to read bitwise types from userspace using get_user.  At the
> > > moment this triggers sparse errors, since the value is passed through an
> > > integer.
> > > 
> > > Fix that up using __force.
> > > 
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > 
> > > Acked-by: Will Deacon <will.deacon@arm.com>
> > 
> > I'm not sure who's going to merge this series. In the meantime, I
> > cherry-picked the arm64 patch. Thanks.
> 
> I think there was a pull request for the whole series that went to Arnd, so
> I don't think we need to do anything on the arm64 side.

OK. I dropped the patch.

-- 
Catalin
