Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab3DDGnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 02:43:12 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6556 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932424Ab3DDGnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 02:43:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 03 Apr 2013 23:42:07 -0700
Message-ID: <515D2115.7020306@nvidia.com>
Date: Thu, 4 Apr 2013 09:43:33 +0300
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "airlied@linux.ie" <airlied@linux.ie>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [PATCHv9 0/9] Support Tegra 2D hardware
References: <1363962849-19872-1-git-send-email-tbergstrom@nvidia.com> <20130322145454.GA3231@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130322145454.GA3231@avionic-0098.mockup.avionic-design.de>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.03.2013 16:54, Thierry Reding wrote:
> On Fri, Mar 22, 2013 at 04:34:00PM +0200, Terje Bergstrom wrote:
>> This set of patches adds support for Tegra20 and Tegra30 host1x and
>> 2D. It is based on linux-next-20130322 with RTC fixes applied.
(...)
> For the series:
> 
> Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
> Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
> 
> For the Tegra DRM bits:
> 
> Acked-by: Thierry Reding <thierry.reding@avionic-design.de>

Dave,

What's the status of this patch? The patch set is not yet merged in your
tree. Did I forget to do some step?

Terje
