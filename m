Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681Ab3LFUcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:32:01 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35206 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab3LFUb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:31:59 -0500
Message-ID: <52A2343A.2090008@wwwdotorg.org>
Date: Fri, 06 Dec 2013 13:31:54 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: kai.poggensee@avionic-design.de, Liam Girdwood <lgirdwood@gmail.com>,
        thierry.reding@gmail.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dev@lynxeye.de,
        sameo@linux.intel.com, broonie@kernel.org,
        Stefan Agner <stefan@agner.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] mfd: tps6586x: add version detection
References: <cover.1386333697.git.stefan@agner.ch>	<7812fb79beac0a6a409090f43d129893f9f93b5b.1386333697.git.stefan@agner.ch>	<52A20E09.7090005@wwwdotorg.org> <CAF2Aj3i95j+ZG4gmpSS9Hq6AKXj6w7mB1psYQwT6oas3QfNBrA@mail.gmail.com>
In-Reply-To: <CAF2Aj3i95j+ZG4gmpSS9Hq6AKXj6w7mB1psYQwT6oas3QfNBrA@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 01:24 PM, Lee Jones wrote:
> 
> On 6 Dec 2013 17:49, "Stephen Warren" <swarren@wwwdotorg.org
> <mailto:swarren@wwwdotorg.org>> wrote:
>>
>> On 12/06/2013 05:51 AM, Stefan Agner wrote:
>> > Use the VERSIONCRC to determine the exact device version. According to
>> > the datasheet this register can be used as device identifier. The
>> > identification is needed since some tps6586x regulators use a different
>> > voltage table.
>>
>> FWIW, this version looks good to me now.
> 
> If that's an Ack I can apply it.

Yes, it is. I thought you said you'd already applied it though, so I
didn't write the ack, but if not:

Acked-by: Stephen Warren <swarren@nvidia.com>
