Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab3DONZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 09:25:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:44503 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab3DONZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 09:25:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,476,1363158000"; 
   d="scan'208";a="295095629"
Date: Mon, 15 Apr 2013 15:25:19 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: x0172184 <x0172184@ti.com>
Cc: "BAJWA, MEHAR" <mehar.bajwa@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Navada Kanyana, Mukund" <navada@ti.com>,
        "liam.r.girdwood@intel.com" <liam.r.girdwood@intel.com>
Subject: Re: [PATCH: v2]:
 Mfd-Initial-support-for-Texas-Instruments-AIC-family-Codecs
Message-ID: <20130415132519.GI8798@zurbaran>
References: <511DFF8A.1080801@ti.com>
 <7506746A41B00D4598AF8BB18AB156933E9116F8@DBDE01.ent.ti.com>
 <20130405155151.GG17363@zurbaran>
 <516BEE8B.5010409@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516BEE8B.5010409@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 05:41:55PM +0530, x0172184 wrote:
> On Friday 05 April 2013 09:21 PM, Samuel Ortiz wrote:
> >Hi Mehar,
> >
> >On Sun, Feb 17, 2013 at 05:15:38AM +0000, BAJWA, MEHAR wrote:
> >>Hi Samuel,
> >>     I am re-sending the MFD support for AIC family of Audio CODECs
> >>from Texas Instruments. The patch was tested on mfd-for-linus-3.8-1.
> >>I would like to request that this be considered for inclusion in the kernel
> >>at the next available window. Could you please let me know if you have
> >>any comments/recommendations for this patch. We would like to work on it
> >>and get it up-streamed.
> >The patch looks good to me, but I'd like it to be splitted in several pieces.
> >You can probably place the core, the irq, the spi and the i2c pieces in their
> >own patches.
> >
> >Cheers,
> >Samuel.
> >
> Hi Samuel,
>     Thanks for your comments. As suggested by you, I am sending
> individual patches as version 2.
Please do not send them as attached patches, but inlined. One patch per
email and threaded, please.

Cheers,
Samuel. 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
