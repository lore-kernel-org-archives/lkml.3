Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbaIJIjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:39:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58147 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaIJIjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:39:14 -0400
Message-ID: <54100E0C.7070309@ti.com>
Date: Wed, 10 Sep 2014 14:08:36 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <srinivas.kandagatla@gmail.com>, <maxime.coquelin@st.com>,
        <patrice.chotard@st.com>, <lee.jones@linaro.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH 0/3]  Add picoPHY usb phy driver found on stih407 family
 SoC's
References: <1409740079-16554-1-git-send-email-peter.griffin@linaro.org> <540DC9F6.8090306@ti.com> <20140908155331.GA7620@griffinp-ThinkPad-X1-Carbon-2nd>
In-Reply-To: <20140908155331.GA7620@griffinp-ThinkPad-X1-Carbon-2nd>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Monday 08 September 2014 09:23 PM, Peter Griffin wrote:
> Hi Kishon,
> 
>> On Wednesday 03 September 2014 03:57 PM, Peter Griffin wrote:
>>> This series adds support for the picoPHY usb phy which is used by the usb2
>>> and usb3 host controllers when controlling usb2/1.1 devices. It is found on
>>> stih407 family SoC's from the consumer electronics devision of STMicroelectronics.
>>
>> So miphy28lp is the PHY controller for USB3 device controller and picoPHY is
>> the PHY controller for USB3 host controller?
> 
> No, miphy28lp is the usb3 phy and picoPHY is the usb2 phy.
> 
> With a usb2 host controller only picoPHY is used. With the usb3 host controller both usb2 and usb3 phys
> are used depending on what type of device is plugged in.
> 
> Hope that clarifies things,

indeed. thanks for the explanation :-)

Cheers
Kishon
