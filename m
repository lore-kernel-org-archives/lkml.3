Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161939Ab3LFWNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:13:42 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:39975 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161178Ab3LFWNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 17:13:40 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <8510201.646121386287761039.JavaMail.weblogic@epml02>
References: <8510201.646121386287761039.JavaMail.weblogic@epml02>
Date: Fri, 6 Dec 2013 14:13:39 -0800
Message-ID: <CAOesGMiZp6j0+pzCE-y_U-JcQZVOagnBV6T-bVH4DPnV8TsYjw@mail.gmail.com>
Subject: Re: [PATCH] ARM: Kill CONFIG_MTD_PARTITIONS
From: Olof Johansson <olof@lixom.net>
To: eunb.song@samsung.com
Cc: "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Dec 5, 2013 at 3:56 PM, Eunbong Song <eunb.song@samsung.com> wrote:
>
> This patch removes CONFIG_MTD_PARTITIONS in config files for ARM.
> Because CONFIG_MTD_PARTITIONS was removed by commit 6a8a98b22b10f1560d5f90aded4a54234b9b2724.
>
> Signed-off-by: Eunbong Song <eunb.song@samsung.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

I don't actually see a need to do this. It creates churn on all
defconfigs, and we have other config entries that have come and gone
over time that would need the same. The way we do defconfigs now,
defaults will just be selected accordingly and having a bit of stale
data in there isn't a big deal.

(And before someone attempts to run 'savedefconfig' across all configs
and send patches for that: Please don't. See above).



-Olof
