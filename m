Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402Ab3BFPLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 10:11:46 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:37557 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab3BFPLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 10:11:45 -0500
MIME-Version: 1.0
In-Reply-To: <20130205235626.GS25185@atomide.com>
References: <1359660284-5225-1-git-send-email-ruslan.bilovol@ti.com>
	<1359660284-5225-2-git-send-email-ruslan.bilovol@ti.com>
	<20130205235626.GS25185@atomide.com>
Date: Wed, 6 Feb 2013 17:11:44 +0200
X-Google-Sender-Auth: nxaPBVm8qzqJUOp1sm7NPkUomaI
Message-ID: <CAB=otbQHmBdDs7crwXLni4sNDFUeM+56eEGhcOKAHjEDpX1R0Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: OMAP2+: SoC name and revision unification
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 1:56 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Ruslan Bilovol <ruslan.bilovol@ti.com> [130131 11:28]:
>> This is a long story where for each new generation of
>> OMAP we used different approaches for creating
>> strings for SoCs names and revisions that this patch
>> fixes. It makes future exporting of this information
>> to SoC infrastructure easier.
>
> Maybe use name soc_name and soc_rev instead and make
Yes agree, will change in next patchset

> cpu_name and cpu_rev local to the functions?
> That would reduce some churn here.
This is used in second patch in this series

>
> Also this does not apply to my omap-for-v3.9/soc
> branch. Care to update this (and possibly the second one)
> against that?
Yes, I will rebase the patches on top of this branch.

>
> Regards,
>
> Tony
