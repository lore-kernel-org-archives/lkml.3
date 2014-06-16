Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbaFPPY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:24:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596AbaFPPYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:24:55 -0400
Message-ID: <1402932269.3707.35.camel@ul30vt.home>
Subject: Re: [PATCH 0/3] iommu: Expose IOMMU information in sysfs
From: Alex Williamson <alex.williamson@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org
Date: Mon, 16 Jun 2014 09:24:29 -0600
In-Reply-To: <20140616151619.GA31771@8bytes.org>
References: <20140612215954.2754.30263.stgit@bling.home>
	 <20140616151619.GA31771@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-16 at 17:16 +0200, Joerg Roedel wrote:
> On Thu, Jun 12, 2014 at 04:12:18PM -0600, Alex Williamson wrote:
> > Alex Williamson (3):
> >       iommu: Add sysfs support for IOMMUs
> >       iommu/intel: Make use of IOMMU sysfs support
> >       iommu/amd: Add sysfs support
> 
> I like the general approach. But why do you only enable the x86 iommus?
> Some ARM IOMMUs and PAMU would certainly also benefit from a sysfs
> representation of which device is translated by which IOMMU.

Only because I have no ability to test the others platforms.  I'd be
thrilled if someone working on those IOMMUs could validate this on
non-x86.  Thanks,

Alex

