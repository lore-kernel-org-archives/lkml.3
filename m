Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab3JHQqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:46:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54826 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531Ab3JHQqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:46:18 -0400
Message-ID: <525436D5.8010707@wwwdotorg.org>
Date: Tue, 08 Oct 2013 10:46:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Arto Merilainen <amerilainen@nvidia.com>, tbergstrom@nvidia.com,
        treding@nvidia.com
CC: dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkulkarni@nvidia.com
Subject: Re: [PATCHv4 0/5] gpu: host1x: Add runtime pm support
References: <1381213648-5931-1-git-send-email-amerilainen@nvidia.com>
In-Reply-To: <1381213648-5931-1-git-send-email-amerilainen@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2013 12:27 AM, Arto Merilainen wrote:
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

The series, briefly,
Reviewed-by: Stephen Warren <swarren@nvidia.com>
