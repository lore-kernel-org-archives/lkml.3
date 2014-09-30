Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220AbaI3WCD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:02:03 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:52053 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302AbaI3WB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 18:01:59 -0400
Message-ID: <542B2851.2050705@gmail.com>
Date: Wed, 01 Oct 2014 00:01:53 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
To: David Miller <davem@davemloft.net>, antoine.tenart@free-electrons.com
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/10] ARM: Berlin: Ethernet support
References: <1412087296-18475-1-git-send-email-antoine.tenart@free-electrons.com> <20140930.163735.2099691931550261883.davem@davemloft.net>
In-Reply-To: <20140930.163735.2099691931550261883.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.09.2014 22:37, David Miller wrote:
> From: Antoine Tenart <antoine.tenart@free-electrons.com>
> Date: Tue, 30 Sep 2014 16:28:06 +0200
>
>> This series introduce support for the Ethernet controller on Berlin SoCs,
>> using the existing pxa168 Ethernet driver. In order to do this, DT
>> support is added to the driver alongside some other modifications and
>> fixes.
>>
>> This has been tested on a Berlin BG2Q DMP board.
>
> Applied to net-next, thanks.

David,

usually I'd prefer to take the dts patches through berlin and arm-soc
tree, _but_ as they are touching berlin stuff only I am fine with you
taking them, too.

Just to make sure how long I have to take care of potential merge
issues, is your current net-next meant for v3.18 or v3.19?

Sebastian
