Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaJBJUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 05:20:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57957 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbaJBJUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 05:20:22 -0400
Date: Thu, 2 Oct 2014 11:20:17 +0200
From: Joerg Roedel <jroedel@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] iommu/vt-d: Keep RMRR mappings around on driver
 unbind
Message-ID: <20141002092017.GA1824@suse.de>
References: <1412074923-6342-1-git-send-email-joro@8bytes.org>
 <20141001223510.GB12989@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141001223510.GB12989@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 03:35:10PM -0700, Greg Kroah-Hartman wrote:
> I have no objection to these, do you want me to take them through my
> tree?  Or if they are going through some other one feel free to add:
> 
> 	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> To the first patch.

Thanks Greg! I added the patches to the IOMMU tree.


	Joerg

