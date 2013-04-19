Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277Ab3DSQao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:30:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:39393 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756979Ab3DSQal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:30:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,510,1363158000"; 
   d="scan'208";a="229346691"
Date: Fri, 19 Apr 2013 18:30:17 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: wwang <wei_wang@realsil.com.cn>
Cc: cjb@laptop.org, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, gregkh@linuxfoundation.org,
        rogerable@realtek.com
Subject: Re: [PATCH v2] mfd:rtsx: Support RTS5249
Message-ID: <20130419163017.GB11866@zurbaran>
References: <cover.1365648007.git.wei_wang@realsil.com.cn>
 <6b09b5138a549e49ea2d27bfee0e36c7aebb0a1b.1365648007.git.wei_wang@realsil.com.cn>
 <20130418225022.GF8798@zurbaran>
 <5170A2E9.1030704@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5170A2E9.1030704@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

On Fri, Apr 19, 2013 at 09:50:33AM +0800, wwang wrote:
> 于 2013年04月19日 06:50, Samuel Ortiz 写道:
> >Hi Wei,
> >
> >On Thu, Apr 11, 2013 at 10:43:40AM +0800, wei_wang@realsil.com.cn wrote:
> >>From: Wei WANG <wei_wang@realsil.com.cn>
> >>
> >>Support new model: RTS5249
> >Could you please provide me with a more detailled changelog (What's so
> >different with this model that the current driver does not support ?) before I
> >apply it ?
> >
> >Cheers,
> >Samuel.
> >
> 
> The difference is minor except that RTS5249 supports SD UHS-II interface.
> 
> In order to support SD UHS-II，the definitions of some internal
> registers of RTS5249 have to be modified and are different from its
> predecessors. So we need this patch to ensure RTS5249 can work, even
> SD/MMC stack doesn't support UHS-II interface.
Patch applied and pushed now, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
