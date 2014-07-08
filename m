Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbaGHNe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:34:29 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6206 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbaGHNe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:34:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 08 Jul 2014 06:27:30 -0700
Message-ID: <53BBF35F.6040809@nvidia.com>
Date: Tue, 8 Jul 2014 16:34:23 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>
CC: Stephen Warren <swarren@wwwdotorg.org>, "tj@kernel.org" <tj@kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 0/9] Serial ATA support for NVIDIA Tegra124
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com> <5390A8F9.2090408@wwwdotorg.org> <53915F3B.6050806@nvidia.com> <5395FE0E.80105@wwwdotorg.org> <539601B4.1010707@kapsi.fi> <20140708130827.GD9516@ulmo>
In-Reply-To: <20140708130827.GD9516@ulmo>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/14 16:08, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Mon, Jun 09, 2014 at 09:49:24PM +0300, Mikko Perttunen wrote:
>> On 06/09/2014 09:33 PM, Stephen Warren wrote:
>>> On 06/06/2014 12:27 AM, Mikko Perttunen wrote:
>>>> The only compile-time dependencies here should be that:
>>>> - patch 8 of 9 which contains the actual driver depends on patch 6 of 9
>>>> (though only when building as a module) and the efuse series
>>>
>>>> - patch 2 of 9 refers to the DT node called "padctl", so it requires the
>>>> xusb series. (in the submitted xusb series, the node isn't actually
>>>> named, though. I will fix this in v2)
>>>
>>> Isn't that dependency a run-time dependency?
>>
>> Well, the kernel will compile but the DTC step will fail if building for
>> Tegra.
>
> Since this is all changes to the DTS files, we can resolve that
> dependency in the Tegra tree by applying the XUSB padctl series
> immediately before this patch, right?

Yes.

(Also I just realized that though the fuse series is in -next, the pull 
request was NAK'd for now, so don't merge this before that is sorted out.)

>
> Thierry
>
> * Unknown Key
> * 0x7F3EB3A1
>

- Mikko
