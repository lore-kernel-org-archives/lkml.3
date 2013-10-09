Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab3JIGlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 02:41:05 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15136 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab3JIGlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 02:41:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 08 Oct 2013 23:41:01 -0700
Message-ID: <5254FADF.7060709@nvidia.com>
Date: Wed, 9 Oct 2013 09:42:39 +0300
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Arto Merilainen <amerilainen@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
CC: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mayuresh Kulkarni <mkulkarni@nvidia.com>
Subject: Re: [PATCHv4 0/5] gpu: host1x: Add runtime pm support
References: <1381213648-5931-1-git-send-email-amerilainen@nvidia.com>
In-Reply-To: <1381213648-5931-1-git-send-email-amerilainen@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.10.2013 09:27, Arto Merilainen wrote:
> This series adds runtime pm support for host1x, gr2d and dc. It retains the
> current behaviour if CONFIG_PM_RUNTIME is not enabled.
> 
> The gr2d clock is enabled when a new job is submitted and disabled when
> the work is done. Due to parent->child relations between host1x->gr2d, this
> scheme enables and disables host1x clock.
> 
> For dc, the clocks are enabled in .probe and disabled in .remove via runtime
> pm instead of direct clock APIs.
> 
> Mayuresh is unfortunately not available to continue with the series and hence
> I will continue working on the patches.

The series,

Acked-By: Terje Bergstrom <tbergstrom@nvidia.com>

Terje

