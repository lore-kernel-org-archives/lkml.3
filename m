Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaBDIpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 03:45:05 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:17169 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaBDIor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:44:47 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 04 Feb 2014 00:42:56 -0800
Message-ID: <52F0A879.7040101@nvidia.com>
Date: Tue, 4 Feb 2014 17:44:41 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ben Skeggs <skeggsb@gmail.com>
CC: Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Alexandre Courbot <gnurou@gmail.com>, Eric Brower <ebrower@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Terje Bergstrom <tbergstrom@nvidia.com>, Ken Adams <KAdams@nvidia.com>
Subject: Re: [RFC 00/16] drm/nouveau: initial support for GK20A (Tegra K1)
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com> <CACAvsv4QFSL8u8hQFr-T_28n3icN_CwDsvLtrcPXx5nErD89wQ@mail.gmail.com>
In-Reply-To: <CACAvsv4QFSL8u8hQFr-T_28n3icN_CwDsvLtrcPXx5nErD89wQ@mail.gmail.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 12:53 PM, Ben Skeggs wrote:
> On Sat, Feb 1, 2014 at 1:16 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> Hello everyone,
> Hey Alex,
>
> The series looks pretty good to me.  I'll reply to the relevant
> patches with any minor nit-picks on top of what's already been said by
> others.

Thanks for the review and the welcome. The first part (infrastructure 
changes to support platform devices) has not really been commented yet. 
If this means it is already in acceptable shape, I propose to re-submit 
it separately so it can be merged ahead of the rest. Let me know if you 
would like us to generalize the use of the bus abstraction functions 
throughout the driver.

For the actual GK20A support, what worries me the most is the memory 
model, and my very incomplete understanding of how Nouveau manages 
memory doesn't help here. I hope to get some more feedback about it and 
see if we can fit somewhere before attempting broader changes.

Thanks!
Alex.

