Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab3HBPcD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 11:32:03 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:52758 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab3HBPcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 11:32:01 -0400
MIME-Version: 1.0
In-Reply-To: <20130802151622.GA27748@konrad-lan.dumpdata.com>
References: <20130802151622.GA27748@konrad-lan.dumpdata.com>
Date: Fri, 2 Aug 2013 11:32:00 -0400
Message-ID: <CADnq5_PsB6JLiptt0gYou3CfZmGr5m=_w_18R7wULr3E67Tdgg@mail.gmail.com>
Subject: Re: Regression introduced by 31f731a drm/radeon/dpm: fix calculations
 in si_calculate_leakage_for_v_and_t_formula
From: Alex Deucher <alexdeucher@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: alexander.deucher@amd.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, airlied@linux.ie
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 2, 2013 at 11:16 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> Hey Alex,
>
> Your recent patch "31f731a drm/radeon/dpm: fix calculations in
> si_calculate_leakage_for_v_and_t_formula" causes a build regression:
>
> drivers/built-in.o: In function `si_calculate_leakage_for_v_and_t_formula':
> /home/build/linux-linus/drivers/gpu/drm/radeon/si_dpm.c:1770: undefined
> reference to `__divdi3'
>
> Which I think is due to the misplace parentheses.

Fixed with this patch:
http://lists.freedesktop.org/archives/dri-devel/2013-August/042668.html

Alex
