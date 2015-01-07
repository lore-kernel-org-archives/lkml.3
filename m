Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbbAGOFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:05:05 -0500
Received: from fortimail.online.lv ([81.198.164.220]:51095 "EHLO
	fortimail.online.lv" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbbAGOFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:05:03 -0500
Message-ID: <54AD3D0B.6060501@apollo.lv>
Date: Wed, 07 Jan 2015 16:04:59 +0200
From: Raimonds Cicans <ray@apollo.lv>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0)
 Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org
Subject: Re: Questions about IOMMU & PCIe switch
References: <54ACB0D4.3000008@apollo.lv> <54AD21E2.2020100@ladisch.de>
In-Reply-To: <54AD21E2.2020100@ladisch.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
DomainKey-Status: no signature
DKIM-Status: no signature
X-AXIGEN-DK-Result: No records
X-AXIGEN-DKIM-Result: No records
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.01.2015 14:09, Clemens Ladisch wrote:
> Raimonds Cicans wrote:
>> We have two kinds of PCIe cards:
>> A1 - based on chip B
>> A2 - based on same chip B but behind PCIe switch
>>
>> Card A1 work flawlessly in any configuration,
>> but card A2 work flawlessly only if system
>> lack IOMMU or have disabled IOMMU
> In theory, such a switch should be transparent.
>
>> Do we have to treat card with PCIe switch in special way?
> No.  But the switch has to work correctly, and driver must be
> written correctly.
>
> Which switch?  Which driver?

We talk about TBS 6285 Quad DVB-T PCIe receiver card.
Starting from version V20 manufacturer added Pericom
PCIe switch PI7C9X2G304SL.

Card have 2 out of kernel drivers:
1) Semi open from TBS:
http://www.tbsdtv.com/download/document/common/tbs-linux-drivers_v141225.zip

2) Open from: https://github.com/ljalves/linux_media

If you want more information you can look at open ticket:
https://github.com/ljalves/linux_media/issues/66


Raimonds Cicans

