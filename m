Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbaKRFTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 00:19:34 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:33023 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbaKRFTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 00:19:33 -0500
Message-ID: <546AD6D6.5070205@ti.com>
Date: Tue, 18 Nov 2014 10:49:18 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vivek Gautam <gautamvivek1987@gmail.com>
CC: Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        <andrew.kim@intel.com>
Subject: Re: [PATCHv4 2/6] phy: improved lookup method
References: <1413556756-5050-1-git-send-email-heikki.krogerus@linux.intel.com> <1413556756-5050-3-git-send-email-heikki.krogerus@linux.intel.com> <CAFp+6iH2oPT-HyJhFCXVCL4eUOQ0AFfxuyGsnXzPv9JTo55+VQ@mail.gmail.com> <5461AFD3.5020302@ti.com> <CAFp+6iGJBSpA5+Q7WQVu0+y-mfoN-E+LmYedipVfgXFZOpr+Cw@mail.gmail.com> <5461CDDF.4090209@ti.com> <CAFp+6iGAQMgX8S6dfPO44U=r6QJ4fT+1FX2uHNF9KK4sYs+=XA@mail.gmail.com> <CAFp+6iHta15CuBbsoQxEo2xr5GyXDgXQ=cg_Q_vOSC7akX0Vcw@mail.gmail.com> <20141117154028.GD7512@kuha.fi.intel.com>
In-Reply-To: <20141117154028.GD7512@kuha.fi.intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 17 November 2014 09:10 PM, Heikki Krogerus wrote:
> On Thu, Nov 13, 2014 at 07:03:01PM +0530, Vivek Gautam wrote:
>> How about adding the change in attached patch [1] on top of this patch.
>> Just introduced the phy pointer in "phy_lookup" structure, and
>> modified phy_find() accordingly.
> 
> I would be fine if we used the phy pointer to match, but if we have
> the pointer to the phy in the lookup, then I would say we need to
> remove the phy_name member.
> 
> Otherwise we would have to support two ways of finding the lookups
> (one for the "static" lookups where we match to the phy_name and other
> where we match to the pointer). That means we will also not be able to
> create "static" lookups, but those would be only needed if we wanted to
> create them in board files. I don't think there will ever be need to
> create the lookups in board files, so I'm more then happy to remove
> the static way of creating the lookups.

Just using the phy pointer sounds good. But interested to know where the phy
pointer will be added to the lookup table.

Thanks
Kishon
