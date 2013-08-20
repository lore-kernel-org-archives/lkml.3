Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab3HTIWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:22:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:53153 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab3HTIWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:22:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,918,1367996400"; 
   d="scan'208";a="388937085"
Date: Tue, 20 Aug 2013 10:22:38 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: wei_wang@realsil.com.cn
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, rogerable@realtek.com,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v3 0/6] MFD patches for Realtek cardreader
Message-ID: <20130820082238.GB7994@zurbaran>
References: <cover.1376978825.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1376978825.git.wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

On Tue, Aug 20, 2013 at 02:18:50PM +0800, wei_wang@realsil.com.cn wrote:
> From: Wei WANG <wei_wang@realsil.com.cn>
> 
> v3:
> Seperate copyright changes to a distinct patch
> Modify some coding style and naming style
> Fix a bug that sd30_drive_sel would be assigned a wrong value, in rts5227 and rts5249
> 
> v2:
> Use macro when initializing vendor settings
> 
> Wei WANG (6):
>   mfd:rtsx: Read vendor setting from config space
>   mfd:rtsx: Add shutdown callback in rtsx_pci_driver
>   mfd:rtsx: Move some actions from rtsx_pci_init_hw to individual
>     extra_init_hw
>   mfd:rtsx: Clear hardware PFM mode in rtl8411b
>   mfd:rtsx: Configure to enter a deeper power-saving mode in S3
>   mfd:rtsx: Modify copyright comments
All 6 patches applied now, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
