Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbaBDIjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 03:39:31 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:17028 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaBDIjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:39:12 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 04 Feb 2014 00:37:20 -0800
Message-ID: <52F0A72B.8030900@nvidia.com>
Date: Tue, 4 Feb 2014 17:39:07 +0900
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
Subject: Re: [RFC 10/16] drm/nouveau/timer: skip calibration on GK20A
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>	<1391224618-3794-11-git-send-email-acourbot@nvidia.com> <CACAvsv4T=TRb05OtkxG=t1+Ou9=Of9c-ALWkHJjKYpNi2aGs5Q@mail.gmail.com>
In-Reply-To: <CACAvsv4T=TRb05OtkxG=t1+Ou9=Of9c-ALWkHJjKYpNi2aGs5Q@mail.gmail.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 12:55 PM, Ben Skeggs wrote:
> On Sat, Feb 1, 2014 at 1:16 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> GK20A's timer is directly attached to the system timer and cannot be
>> calibrated. Skip the calibration phase on that chip since the
>> corresponding registers do not exist.
> Just a curiosity:  What timer resolution does the HW initialise at?

On T124 the timer input is the oscillator clock, which depending on the 
device can run between 12 and 48Mhz (IIUC).
