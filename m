Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaKNOPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:15:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:21188 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597AbaKNOPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:15:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="416507383"
Date: Fri, 14 Nov 2014 16:15:35 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        andrew.kim@intel.com
Subject: Re: [PATCHv4 2/6] phy: improved lookup method
Message-ID: <20141114141535.GB7512@kuha.fi.intel.com>
References: <1413556756-5050-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1413556756-5050-3-git-send-email-heikki.krogerus@linux.intel.com>
 <CAFp+6iH2oPT-HyJhFCXVCL4eUOQ0AFfxuyGsnXzPv9JTo55+VQ@mail.gmail.com>
 <5461AFD3.5020302@ti.com>
 <CAFp+6iGJBSpA5+Q7WQVu0+y-mfoN-E+LmYedipVfgXFZOpr+Cw@mail.gmail.com>
 <5461CDDF.4090209@ti.com>
 <CAFp+6iGAQMgX8S6dfPO44U=r6QJ4fT+1FX2uHNF9KK4sYs+=XA@mail.gmail.com>
 <CAFp+6iHta15CuBbsoQxEo2xr5GyXDgXQ=cg_Q_vOSC7akX0Vcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFp+6iHta15CuBbsoQxEo2xr5GyXDgXQ=cg_Q_vOSC7akX0Vcw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

On Thu, Nov 13, 2014 at 07:03:01PM +0530, Vivek Gautam wrote:
> Hi Heikki, Kishon,
> 
> How about adding the change in attached patch [1] on top of this patch.
> Just introduced the phy pointer in "phy_lookup" structure, and
> modified phy_find() accordingly.
> 
> [1] Attachment:
>     0001-phy-core-Use-phy-pointer-with-phy_lookup_table.patch

Just to let you know, I'm finally able to work on this again.

I was actually thinking that we should just roll back to the previous
version where I didn't yet use the parent name, and rethink how to
solve the problem Kishon pointed out.

But, I'll take a look at this properly on Monday.


Cheers,

-- 
heikki
