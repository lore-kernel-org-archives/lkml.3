Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbaEWHOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 03:14:12 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:61034 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbaEWHOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 03:14:08 -0400
MIME-Version: 1.0
In-Reply-To: <537A7450.5030904@wwwdotorg.org>
References: <1400491450-19223-1-git-send-email-acourbot@nvidia.com>
 <1400491450-19223-3-git-send-email-acourbot@nvidia.com> <537A7450.5030904@wwwdotorg.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 23 May 2014 16:13:47 +0900
Message-ID: <CAAVeFuK_DbvukzvnNrDLOLPAYThEoy-TMgU65COa1xUHyChFUQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] ARM: tegra: of: add GK20A device tree binding
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Ben Skeggs <bskeggs@redhat.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 6:14 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 05/19/2014 03:24 AM, Alexandre Courbot wrote:
>> Add the device tree binding documentation for the GK20A GPU used in
>> Tegra K1 SoCs.
>
> A few minor nits, but otherwise,
> Acked-by: Stephen Warren <swarren@nvidia.com>
>
>> diff --git a/Documentation/devicetree/bindings/gpu/nvidia,gk20a.txt b/Documentation/devicetree/bindings/gpu/nvidia,gk20a.txt
>
>> +Required properties:
>> +- compatible: "nvidia,<chip>-<gpu>"
>> +  Currently recognized values:
>> +  - nvidia,tegra124-gk20a
>> +- reg: Physical base address and length of the controller's registers.
>> +  Must contain two entries:
>> +  - first entry for bar0
>> +  - second entry for bar1
>> +- interrupts: The interrupt outputs from the controller.
>
> To be consistent with the clocks and resets properties, it'd be nice to
> reword that as:
>
> interrupts: Must contain an entry for each entry in interrupt-names.
>
>> +- interrupt-names: Must include the following entries:
>
> ... and add the following here:
>
> See ../interrupt-controller/interrupts.txt
>
>> +/ {
>
> No need to wrap a root node around this in the example.
>
>> +     gpu@0,57000000 {
> ...
>> +     };
>> +
>
> Extra blank line here.
>
>> +};
>

All fixed and acked-by added to the commit log.

Thanks,
Alex.
