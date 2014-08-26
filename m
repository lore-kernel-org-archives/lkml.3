Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797AbaHZLwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 07:52:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38972 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbaHZLwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:52:50 -0400
Message-ID: <53FC74E8.80206@ti.com>
Date: Tue, 26 Aug 2014 17:22:08 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, <robh+dt@kernel.org>
CC: <devicetree@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux@arm.linux.org.uk>, <pawel.moll@arm.com>,
        <khilman@deeprootsystems.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 0/6] ARM: DT/davinci: Audio for da850-evm in DT boot
References: <1406873610-5037-1-git-send-email-peter.ujfalusi@ti.com> <53FC6069.7000105@ti.com>
In-Reply-To: <53FC6069.7000105@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 August 2014 03:54 PM, Sekhar Nori wrote:
> On Friday 01 August 2014 11:43 AM, Peter Ujfalusi wrote:
>> Hi,
>>
>> Changes since v1:
>> - fixed the address missmatch for tlv320aic3106 codec (@1b -> 18)
>> - The edma patches has been taken by Vinod, they should be in linux-next soon.
> 
> I assume all of these 6 patches are meant to go through ARM SoC. I have
> applied all of them for v3.18.
> 
>> The following series will enable audio via simple card on the board when booted
>> with DT.
> 
> Thanks for doing this.

Also tested audio playback and record on DA850 EVM. Works great!

Thanks,
Sekhar
