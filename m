Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbaIYR34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 13:29:56 -0400
Received: from 8bytes.org ([81.169.241.247]:59556 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbaIYR3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 13:29:55 -0400
Date: Thu, 25 Sep 2014 19:29:52 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Su, Friendy" <Friendy.Su@sony.com.cn>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] iommu/amd: set iommu for early mapped ioapic/hpet
Message-ID: <20140925172952.GF8306@8bytes.org>
References: <053191AD6E9023439BF3970DE870051856D1EF3AC5@APSHAXMS02.ap.sony.com>
 <20140905135320.GP28786@8bytes.org>
 <053191AD6E9023439BF3970DE870051856D274B417@APSHAXMS02.ap.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <053191AD6E9023439BF3970DE870051856D274B417@APSHAXMS02.ap.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 09, 2014 at 04:34:52PM +0800, Su, Friendy wrote:
> > The problem you describe here should also be fixed by this (simpler)
> > patch. Can you test this please?
> 
> The running result of this patch is correct.

Okay, fine, thanks for testing. I queued this patch up for the next
merge window.


	Joerg

