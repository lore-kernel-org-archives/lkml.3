Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbbAMCBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 21:01:42 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:1617 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbbAMCBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 21:01:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 12 Jan 2015 18:00:20 -0800
Message-ID: <54B47C66.1010805@nvidia.com>
Date: Tue, 13 Jan 2015 11:01:10 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>
CC: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?windows-1252?Q?Christian_K=F6nig?= <christian.koenig@amd.com>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm/nouveau/nouveau_bo: Remove unused function
References: <1421015495-24744-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1421015495-24744-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-NVConfidentiality: public
X-Originating-IP: [10.19.57.128]
X-ClientProxiedBy: HKMAIL103.nvidia.com (10.18.16.12) To
 HKMAIL102.nvidia.com (10.18.16.11)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 07:31 AM, Rickard Strandqvist wrote:
> Remove the function nouveau_bo_rd16() that is not used anywhere.
>
> This was partially found by using a static code analysis program called cppcheck.

nouveau_bo_wr16() being presumably used (since it is not removed by this 
patch), it sounds safe to keep its read counterpart?

