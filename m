Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589AbaGCQJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:09:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890AbaGCQJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:09:16 -0400
Message-ID: <1404403726.1862.78.camel@ul30vt.home>
Subject: Re: [PATCH 0/3] iommu: Expose IOMMU information in sysfs
From: Alex Williamson <alex.williamson@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, Varun Sethi <Varun.Sethi@freescale.com>
Date: Thu, 03 Jul 2014 10:08:46 -0600
In-Reply-To: <1402932269.3707.35.camel@ul30vt.home>
References: <20140612215954.2754.30263.stgit@bling.home>
	 <20140616151619.GA31771@8bytes.org> <1402932269.3707.35.camel@ul30vt.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-16 at 09:24 -0600, Alex Williamson wrote:
> On Mon, 2014-06-16 at 17:16 +0200, Joerg Roedel wrote:
> > On Thu, Jun 12, 2014 at 04:12:18PM -0600, Alex Williamson wrote:
> > > Alex Williamson (3):
> > >       iommu: Add sysfs support for IOMMUs
> > >       iommu/intel: Make use of IOMMU sysfs support
> > >       iommu/amd: Add sysfs support
> > 
> > I like the general approach. But why do you only enable the x86 iommus?
> > Some ARM IOMMUs and PAMU would certainly also benefit from a sysfs
> > representation of which device is translated by which IOMMU.
> 
> Only because I have no ability to test the others platforms.  I'd be
> thrilled if someone working on those IOMMUs could validate this on
> non-x86.  Thanks,

Should I re-send this series or are you hoping I'll attempt to piece
together a non-x86 user for which I have no hardware and can't test?
Varun, do you have any interest in this for the fsl iommu to try a proof
of concept?  Thanks,

Alex

