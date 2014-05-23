Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaEWNYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 09:24:41 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53927 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750981AbaEWNYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 09:24:39 -0400
Message-ID: <537F4C0C.1080901@free-electrons.com>
Date: Fri, 23 May 2014 15:24:28 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/5] Documentation: dt-bindings: document the Armada 375
 USB cluster binding
References: <1400257376-13251-1-git-send-email-gregory.clement@free-electrons.com> <1400257376-13251-2-git-send-email-gregory.clement@free-electrons.com> <537F13B2.6070500@ti.com>
In-Reply-To: <537F13B2.6070500@ti.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On 23/05/2014 11:24, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Friday 16 May 2014 09:52 PM, Gregory CLEMENT wrote:
>> Armada 375 comes with an USB2 host and device controller and an USB3
>> controller. The USB cluster control register allows to manage common
>> features of both USB controllers. This commit adds the Device Tree
>> binding documentation for this piece of hardware.
> 
> Pls re-order so that the Documentation patch comes before the driver patch..

OK I will do it

>>
>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>> ---
>>  .../bindings/phy/armada-375-usb-phy-cluster.txt      | 20 ++++++++++++++++++++
>>  1 file changed, 20 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/phy/armada-375-usb-phy-cluster.txt
>>
>> diff --git a/Documentation/devicetree/bindings/phy/armada-375-usb-phy-cluster.txt b/Documentation/devicetree/bindings/phy/armada-375-usb-phy-cluster.txt
> 
> simpler file name? armada-phy?

I can remove the "cluster" part but not the 375, there are many SoCs
from Marvell called Armada, and some of then have nearly nothing in
common, so I prefer keep this name. If your intent is to have a file
with all the PHY binding related to an SoC family, then we should call it
mvebu-phy.


Thanks for your review,

Gregory



-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
