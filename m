Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaHZRIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 13:08:55 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:40674 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbaHZRIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 13:08:54 -0400
MIME-Version: 1.0
In-Reply-To: <53FCBBE2.9040603@arm.com>
References: <CAPXgP130hg8uwdmSKAAAKZzxncT-VXYYXvmN-ta7wcXQXgXEmw@mail.gmail.com>
	<1408706963-23195-1-git-send-email-sudeep.holla@arm.com>
	<CANq1E4SJZQeAuXhggdnsjRFKFJD01WEnBpcdPC1pkJiv3WegCA@mail.gmail.com>
	<CANq1E4Snx_n3XDWXU5PtmLtt31sRqnkKrSRsx2_b=i+6GTLnxw@mail.gmail.com>
	<53F738B0.5080806@arm.com>
	<53FCBBE2.9040603@arm.com>
Date: Tue, 26 Aug 2014 19:08:53 +0200
Message-ID: <CANq1E4SB-o6TD0ayvLGL_M52b-eCR=MU048+fOmx+_y+apFjSA@mail.gmail.com>
Subject: Re: [PATCH] drivers: base: add cpu_device_create to support per-cpu devices
From: David Herrmann <dh.herrmann@gmail.com>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, Aug 26, 2014 at 6:54 PM, Sudeep Holla <sudeep.holla@arm.com> wrote:
>> Yes, it's not done on purpose as mentioned in the commit log.
>> E.g.: cacheinfo topology will be as below
>>
>> /sys/devices/system/cpu/cpuX/cache/index0/<attributes>
>> /sys/devices/system/cpu/cpuX/cache/index1/<attributes>
>> ..
>> /sys/devices/system/cpu/cpuX/cache/index<Y/<attributes>
>>
>
> Does the above topology looks fine to you ? Since the parent is set
> properly, not setting bus will not cause any issue to the topology.

Sure, looks fine.

Thanks
David
