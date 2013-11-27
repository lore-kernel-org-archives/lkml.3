Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134Ab3K0PuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:50:15 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:42289 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab3K0PuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:50:12 -0500
MIME-Version: 1.0
In-Reply-To: <20131127115407.GA6773@amd.pavel.ucw.cz>
References: <20131127115407.GA6773@amd.pavel.ucw.cz>
Date: Wed, 27 Nov 2013 21:20:11 +0530
Message-ID: <CAKohponaGMZu6jU=UCvtS8V5DZxsU9pvWvEK=Nycy7AgxbnXJA@mail.gmail.com>
Subject: Re: omap-cpufreq compilation breakage in 3.13-rc1
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, sre@ring0.de, pali.rohar@gmail.com,
        "arm@kernel.org" <arm@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 November 2013 17:24, Pavel Machek <pavel@ucw.cz> wrote:
> Commit d4019f0a92ab802f385cc9c8ad3ab7b5449712cb broke compilation for
> omap-cpufreq.c . Given impresive list of ACKs and Tested-bys, I'd not
> expect such problem. This fixes it.

Probably none of them have tested this on OMAP :) and actually it was my
mistake that I did during rearranging 230 odd patches..
