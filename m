Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaKQMIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 07:08:13 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:44544 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbaKQMIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 07:08:11 -0500
MIME-Version: 1.0
In-Reply-To: <20141114141535.GB7512@kuha.fi.intel.com>
References: <1413556756-5050-1-git-send-email-heikki.krogerus@linux.intel.com>
	<1413556756-5050-3-git-send-email-heikki.krogerus@linux.intel.com>
	<CAFp+6iH2oPT-HyJhFCXVCL4eUOQ0AFfxuyGsnXzPv9JTo55+VQ@mail.gmail.com>
	<5461AFD3.5020302@ti.com>
	<CAFp+6iGJBSpA5+Q7WQVu0+y-mfoN-E+LmYedipVfgXFZOpr+Cw@mail.gmail.com>
	<5461CDDF.4090209@ti.com>
	<CAFp+6iGAQMgX8S6dfPO44U=r6QJ4fT+1FX2uHNF9KK4sYs+=XA@mail.gmail.com>
	<CAFp+6iHta15CuBbsoQxEo2xr5GyXDgXQ=cg_Q_vOSC7akX0Vcw@mail.gmail.com>
	<20141114141535.GB7512@kuha.fi.intel.com>
Date: Mon, 17 Nov 2014 17:38:10 +0530
Message-ID: <CAFp+6iEAtq2PEF3mGVJN6xaR=G0EWDZbCzBwv-J8J2HXV8e9aw@mail.gmail.com>
Subject: Re: [PATCHv4 2/6] phy: improved lookup method
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        andrew.kim@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 7:45 PM, Heikki Krogerus
<heikki.krogerus@linux.intel.com> wrote:
> Hi Vivek,
>
> On Thu, Nov 13, 2014 at 07:03:01PM +0530, Vivek Gautam wrote:
>> Hi Heikki, Kishon,
>>
>> How about adding the change in attached patch [1] on top of this patch.
>> Just introduced the phy pointer in "phy_lookup" structure, and
>> modified phy_find() accordingly.
>>
>> [1] Attachment:
>>     0001-phy-core-Use-phy-pointer-with-phy_lookup_table.patch
>
> Just to let you know, I'm finally able to work on this again.

Great !!

>
> I was actually thinking that we should just roll back to the previous
> version where I didn't yet use the parent name, and rethink how to
> solve the problem Kishon pointed out.
>
> But, I'll take a look at this properly on Monday.

Cool, was just throwing some ideas, similar to clk driver, like Kishon
suggested.



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
