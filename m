Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaJEUik (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 16:38:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbaJEUij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 16:38:39 -0400
Date: Sun, 5 Oct 2014 13:38:38 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 3.14 104/238] iommu/fsl: Fix warning resulting from
 adding PCI device twice
Message-ID: <20141005203838.GC2528@kroah.com>
References: <20141003212913.680985295@linuxfoundation.org>
 <20141003212917.004490011@linuxfoundation.org>
 <6155d43b3a044373b0d08c7aa6183ae1@BL2PR03MB468.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6155d43b3a044373b0d08c7aa6183ae1@BL2PR03MB468.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 04, 2014 at 10:21:19AM +0000, Varun Sethi wrote:
> Hi Greg,
> This fix is not required on 3.14. Fix was required to address an
> issue, introduced by the iommu_group_get_for_dev API in the PAMU
> driver code.

Thanks for letting me know, now dropped from 3.14.

greg k-h
