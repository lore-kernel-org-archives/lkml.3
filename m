Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213AbaHYRwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:52:30 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48496 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253AbaHYRw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:52:28 -0400
Message-ID: <53FB77F5.3010604@wwwdotorg.org>
Date: Mon, 25 Aug 2014 11:52:53 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>, Pavel Machek <pavel@ucw.cz>,
        Thierry Reding <thierry.reding@gmail.com>
CC: linux-pm@vger.kernel.org,
        =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: Re: [PATCH v3 3/3] memory: tegra124-emc: Add EMC driver
References: <1408437523-8542-1-git-send-email-tomeu.vizoso@collabora.com> <1408437523-8542-4-git-send-email-tomeu.vizoso@collabora.com> <20140819090314.GC7862@amd> <CAAObsKA+JofL3JANtdqAqGgtA3-x+GMQ0Ei7gMzmmWynP3U9Sg@mail.gmail.com>
In-Reply-To: <CAAObsKA+JofL3JANtdqAqGgtA3-x+GMQ0Ei7gMzmmWynP3U9Sg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2014 03:06 AM, Tomeu Vizoso wrote:
> On 19 August 2014 11:03, Pavel Machek <pavel@ucw.cz> wrote:
>> On Tue 2014-08-19 10:38:43, Tomeu Vizoso wrote:
>>> Sets the EMC clock rate based on the bandwidth requirements registered by
>>> memory clients through the PM_QOS_MEMORY_BANDWIDTH class.
>>>
>>> Note: this is just an example and not a proper driver for a external memory
>>> controller. Its only purpose is to illustrate how such a driver
>>> would set the
>>
>> So... you don't want this to be merged?
>
> Not really, there's quite some work left to do until we have a proper
> EMC driver for Tegra124.

Given that, the only patches in this series that should be merged touch 
(a) pm_qos, (b) tegradrm. As such, I would suggest that patch 1 be 
merged into the pm_qos tree in a standalone topic branch, and Thierry 
can merge this into the Tegra tree and apply patch 2 when he's ready.

Since patch 3 is the only patch that would normally go through the Tegra 
tree, and patch 3 isn't to be applied yet, I don't intend on applying 
any of these patches to the Tegra tree.
