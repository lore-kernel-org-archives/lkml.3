Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaCIHfy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 03:35:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47792 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaCIHfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 03:35:53 -0400
Message-ID: <531C19C8.4080806@ti.com>
Date: Sun, 9 Mar 2014 13:05:36 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [GIT PULL 00/28] PHY for 3.15
References: <1394270969-11851-1-git-send-email-kishon@ti.com> <20140308164222.GA28789@kroah.com>
In-Reply-To: <20140308164222.GA28789@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Saturday 08 March 2014 10:12 PM, Greg KH wrote:
> On Sat, Mar 08, 2014 at 02:59:01PM +0530, Kishon Vijay Abraham I wrote:
>> Hi Greg,
>>
>> Here's the PULL REQUEST for 3.15 merge window.
>> More users are starting to use the generic PHY framework including USB and
>> SATA PHY in exynos, USB in sunxi and multi-purpose PHY (currently only SATA)
>> in APM. There is also a patch to adapt USB3 PHY driver (PIPE3) used in OMAP
>> to generic PHY framework and use the same driver for SATA.
>> It also includes few fixes and cleanups.
>>
>> Please let me know if you want me to make any changes.
>>
>> Cheers
>> Kishon
>>
>> The following changes since commit cfbf8d4857c26a8a307fb7cd258074c9dcd8c691:
>>
>>    Linux 3.14-rc4 (2014-02-23 17:40:03 -0800)
>>
>> are available in the git repository at:
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git tags/for_3.15
>>
>> for you to fetch changes up to 303fd52cda953d14dc82ac82b570761599eb9ab2:
>>
>>    PHY: add APM X-Gene SoC 15Gbps Multi-purpose PHY driver (2014-03-08 12:39:51 +0530)
>
> When merging this with my usb-next tree, I get the following merge
> issue, which I don't know how to resolve:
> CONFLICT (modify/delete): Documentation/devicetree/bindings/usb/usb-phy.txt deleted in HEAD and modified in a0100026249158ec7aae606b553efae7cb37f616. Version a0100026249158ec7aae606b553efae7cb37f616 of Documentation/devicetree/bindings/usb/usb-phy.txt left in tree.
>
> Any suggestions as to what I should do here?

There were 3 patches that modified usb-phy.txt but the file was moved to 
phy/ti-phy.txt in balbi's branch. I've resent the patches that modified 
this file and have also updated tags/for_3.15.

Let me know If I have to resend the PULL request.

Sorry for the hassle.

Thanks
Kishon
