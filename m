Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab3FZKAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 06:00:33 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:48594 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3FZKAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 06:00:32 -0400
MIME-Version: 1.0
In-Reply-To: <03c8973cc1e9efcd203e4d95d2dd9469afbcb39b.1372240320.git.michal.simek@xilinx.com>
References: <03c8973cc1e9efcd203e4d95d2dd9469afbcb39b.1372240320.git.michal.simek@xilinx.com>
Date: Wed, 26 Jun 2013 15:30:31 +0530
Message-ID: <CAK9yfHzVSt1XN7=OZOtF_n_3jbpXObqoiay_t6n3EauTjUUX+w@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] uio: Use of_match_ptr() macro in uio_pdrv_genirq.c
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        Pavel Machek <pavel@ucw.cz>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 June 2013 15:22, Michal Simek <michal.simek@xilinx.com> wrote:
> This eliminates having an #ifdef returning NULL for the case
> when OF is disabled.
>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

I have already submitted a similar patch for doing this:
https://lkml.org/lkml/2013/3/14/169

-- 
With regards,
Sachin
