Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaEWNvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 09:51:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33980 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbaEWNvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 09:51:42 -0400
Message-ID: <537F523A.8060603@ti.com>
Date: Fri, 23 May 2014 19:20:50 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/5] Documentation: dt-bindings: document the Armada 375
 USB cluster binding
References: <1400257376-13251-1-git-send-email-gregory.clement@free-electrons.com> <1400257376-13251-2-git-send-email-gregory.clement@free-electrons.com> <537F13B2.6070500@ti.com> <20140523132145.GA31314@lunn.ch>
In-Reply-To: <20140523132145.GA31314@lunn.ch>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 23 May 2014 06:51 PM, Andrew Lunn wrote:
> On Fri, May 23, 2014 at 02:54:02PM +0530, Kishon Vijay Abraham I wrote:
>> Hi,
>>
>> On Friday 16 May 2014 09:52 PM, Gregory CLEMENT wrote:
>>> Armada 375 comes with an USB2 host and device controller and an USB3
>>> controller. The USB cluster control register allows to manage common
>>> features of both USB controllers. This commit adds the Device Tree
>>> binding documentation for this piece of hardware.
>>
>> Pls re-order so that the Documentation patch comes before the driver patch..
>>>
>>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>>> ---
>>>  .../bindings/phy/armada-375-usb-phy-cluster.txt      | 20 ++++++++++++++++++++
>>>  1 file changed, 20 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/phy/armada-375-usb-phy-cluster.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/phy/armada-375-usb-phy-cluster.txt b/Documentation/devicetree/bindings/phy/armada-375-usb-phy-cluster.txt
>>
>> simpler file name? armada-phy?
> 
> Armada is a collection of families of SoCs. This driver is very
> specific to one SoC, in one family of SoCs.
> 
> Do you want one .txt file per driver, or can we combine binding
> documentations into one file? There should already be a mvebu-phy.txt,
> which contains the sata phy usable on some of the Armada SoC families.
> This binding could be appended to it.

So far we've been creating Documentation file per manufacturer (ti-phy.txt,
samsung-phy.txt..), so would prefer if you could combine binding documentation
in a single file.

Thanks
Kishon
