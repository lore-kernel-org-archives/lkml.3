Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903Ab3GYSGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:06:52 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:2955 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757846Ab3GYSGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:06:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 25 Jul 2013 11:06:46 -0700
Message-ID: <51F16935.6000600@nvidia.com>
Date: Thu, 25 Jul 2013 14:06:45 -0400
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>, Joseph Lo <josephl@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [v2 PATCH] regulator: palmas: Store pdata pointer in palmas struct
References: <1374771899-5037-1-git-send-email-rklein@nvidia.com> <20130725180246.GM9858@sirena.org.uk>
In-Reply-To: <20130725180246.GM9858@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/2013 2:02 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
> 
> On Thu, Jul 25, 2013 at 01:04:59PM -0400, Rhyland Klein wrote:
>> Store a pointer to the pdata so that if it needs to be used after
>> probe it can be. In the case of booting from DeviceTree, the
>> dev.platform_data may be null, so we need to store this pointer
>> explicitly.
> 
> This doesn't seem to adjust any places where pdata is used to refer to
> the new pointer so does it actually have any effect?

I was thinking the same thing after I sent this. Right now, no this has
no effect. The expectation is that when ldo8-tracking support is posted,
it needs to have access to the pdata. I suppose it could make sense then
to either make this part of that series, or to flatten this directly
into it.

I think it can be fine to merge on its own, but it might make sense then
to include the ldo8 tracking support. Let me see how ready that is to be
posted, and if it is close, this can join it in a patchset.

-rhyland

> 
> * Unknown Key
> * 0x7EA229BD
> 


-- 
nvpublic
