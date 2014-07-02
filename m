Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbaGBQXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:23:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42829 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbaGBQXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:23:03 -0400
Message-ID: <53B431E4.60404@wwwdotorg.org>
Date: Wed, 02 Jul 2014 10:23:00 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Ben Skeggs <bskeggs@redhat.com>, Alexandre Courbot <acourbot@nvidia.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/3] drm/nouveau: support for probing platform devices
References: <1403760814-26148-1-git-send-email-acourbot@nvidia.com> <CAAVeFu+O+Z7kQ3Sre=WKkcYoxXYUx4zCzZK8cVMj1WAtwA5eMg@mail.gmail.com>
In-Reply-To: <CAAVeFu+O+Z7kQ3Sre=WKkcYoxXYUx4zCzZK8cVMj1WAtwA5eMg@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2014 03:09 AM, Alexandre Courbot wrote:
> On Thu, Jun 26, 2014 at 2:33 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> This series adds support for probing platform devices on Nouveau, as well as
>> the DT bindings for GK20A. It doesn't enable the GPU yet on Tegra boards since
>> a few extra things need to be supported before that.
>>
>> This version is mostly identical to v2 but fixes an important issue: the drvdata
>> must be set to the drm_device for sysfs to work, so the platform device
>> structure now includes the nouveau_device flattened into it to let us compute
>> the address of one from the other. Since the platform device resources (clocks,
>> regulators, ...) need to live longer than the nouveau_device, they are stored
>> into their own structure which is allocated separately.
...
> Stephen, Thierry,
> 
> Ben has merged the first patch of this series into the Nouveau tree.
> Could you get patches 2 and 3 through the Tegra tree? Thanks!

I've applied patches 2 and 3 to Tegra's for-3.17/dt branch.
