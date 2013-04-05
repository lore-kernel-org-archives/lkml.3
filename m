Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161948Ab3DEPv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 11:51:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:42800 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161908Ab3DEPvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 11:51:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,415,1363158000"; 
   d="scan'208";a="314189625"
Date: Fri, 5 Apr 2013 17:51:51 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "BAJWA, MEHAR" <mehar.bajwa@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Navada Kanyana, Mukund" <navada@ti.com>,
        "liam.r.girdwood@intel.com" <liam.r.girdwood@intel.com>
Subject: Re: [RESEND: PATCH]:
 Mfd-Initial-support-for-Texas-Instruments-AIC-family-Codecs
Message-ID: <20130405155151.GG17363@zurbaran>
References: <511DFF8A.1080801@ti.com>
 <7506746A41B00D4598AF8BB18AB156933E9116F8@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7506746A41B00D4598AF8BB18AB156933E9116F8@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mehar,

On Sun, Feb 17, 2013 at 05:15:38AM +0000, BAJWA, MEHAR wrote:
> Hi Samuel,
>     I am re-sending the MFD support for AIC family of Audio CODECs
> from Texas Instruments. The patch was tested on mfd-for-linus-3.8-1.
> I would like to request that this be considered for inclusion in the kernel
> at the next available window. Could you please let me know if you have
> any comments/recommendations for this patch. We would like to work on it
> and get it up-streamed.
The patch looks good to me, but I'd like it to be splitted in several pieces.
You can probably place the core, the irq, the spi and the i2c pieces in their
own patches.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
