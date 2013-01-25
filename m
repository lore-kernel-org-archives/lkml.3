Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab3AYIod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:44:33 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35992 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab3AYIo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:44:29 -0500
Message-ID: <510245D7.4090008@ti.com>
Date: Fri, 25 Jan 2013 14:14:07 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <rob.herring@calxeda.com>, <rob@landley.net>, <sameo@linux.intel.com>,
        <gg@slimlogic.co.uk>, <s-guiriec@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <grant.likely@secretlab.ca>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v1 1/8] usb: otg: palmas-usb: make palmas-usb as a comparator
 driver
References: <1359083551-8524-1-git-send-email-kishon@ti.com> <1359083551-8524-2-git-send-email-kishon@ti.com> <20130125074339.GD15886@arwen.pp.htv.fi>
In-Reply-To: <20130125074339.GD15886@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 January 2013 01:13 PM, Felipe Balbi wrote:
> Hi,
>
> On Fri, Jan 25, 2013 at 08:42:24AM +0530, Kishon Vijay Abraham I wrote:
>> palmas-usb is made as a comparator driver to omap usb2 phy, so that
>> omap usb can make use of palmas for srp and also to set vbus.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>
> doesn't apply. palmas-usb isn't in mainline
>
Yes. We'll ask Rajendra Nayak to pick this up in his tree?

Thanks
Kishon
