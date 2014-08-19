Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbaHSJG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 05:06:29 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:35634 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaHSJG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 05:06:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140819090314.GC7862@amd>
References: <1408437523-8542-1-git-send-email-tomeu.vizoso@collabora.com>
 <1408437523-8542-4-git-send-email-tomeu.vizoso@collabora.com> <20140819090314.GC7862@amd>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Tue, 19 Aug 2014 11:06:05 +0200
X-Google-Sender-Auth: 2G81NaMlEKXGV6P7W_-uY6MRrj4
Message-ID: <CAAObsKA+JofL3JANtdqAqGgtA3-x+GMQ0Ei7gMzmmWynP3U9Sg@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] memory: tegra124-emc: Add EMC driver
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-pm@vger.kernel.org, Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?Q?Terje_Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mperttunen@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 August 2014 11:03, Pavel Machek <pavel@ucw.cz> wrote:
> On Tue 2014-08-19 10:38:43, Tomeu Vizoso wrote:
>> Sets the EMC clock rate based on the bandwidth requirements registered by
>> memory clients through the PM_QOS_MEMORY_BANDWIDTH class.
>>
>> Note: this is just an example and not a proper driver for a external memory
>> controller. Its only purpose is to illustrate how such a driver
>> would set the
>
> So... you don't want this to be merged?

Not really, there's quite some work left to do until we have a proper
EMC driver for Tegra124.

Thanks,

Tomeu
