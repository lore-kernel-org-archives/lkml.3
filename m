Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565AbaBEU1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:27:46 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:50664 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905AbaBEU1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:27:40 -0500
Message-ID: <52F29EB8.5040906@wwwdotorg.org>
Date: Wed, 05 Feb 2014 13:27:36 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>, Ben Skeggs <skeggsb@gmail.com>
CC: Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Alexandre Courbot <gnurou@gmail.com>, Eric Brower <ebrower@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Terje Bergstrom <tbergstrom@nvidia.com>, Ken Adams <KAdams@nvidia.com>
Subject: Re: [RFC 10/16] drm/nouveau/timer: skip calibration on GK20A
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>	<1391224618-3794-11-git-send-email-acourbot@nvidia.com> <CACAvsv4T=TRb05OtkxG=t1+Ou9=Of9c-ALWkHJjKYpNi2aGs5Q@mail.gmail.com> <52F0A72B.8030900@nvidia.com>
In-Reply-To: <52F0A72B.8030900@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 01:39 AM, Alexandre Courbot wrote:
> On 02/04/2014 12:55 PM, Ben Skeggs wrote:
>> On Sat, Feb 1, 2014 at 1:16 PM, Alexandre Courbot
>> <acourbot@nvidia.com> wrote:
>>> GK20A's timer is directly attached to the system timer and cannot be
>>> calibrated. Skip the calibration phase on that chip since the
>>> corresponding registers do not exist.
>> Just a curiosity:  What timer resolution does the HW initialise at?
> 
> On T124 the timer input is the oscillator clock, which depending on the
> device can run between 12 and 48Mhz (IIUC).

On the one Tegra124 board we support upstream, the crystal is 12MHz. I
believe this is a typical/common value; almost all the Tegra boards we
support upstream run at this rate.
