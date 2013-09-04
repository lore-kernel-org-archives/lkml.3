Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850Ab3IDSpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:45:13 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34725 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759478Ab3IDSpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:45:11 -0400
Message-ID: <52277FB3.6050008@wwwdotorg.org>
Date: Wed, 04 Sep 2013 12:45:07 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>
CC: thierry.reding@gmail.com, tbergstrom@nvidia.com,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] clk: tegra114: Initialize clocks needed for HDMI
References: <1377704922-2824-1-git-send-email-mperttunen@nvidia.com> <1377704922-2824-5-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1377704922-2824-5-git-send-email-mperttunen@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 09:48 AM, Mikko Perttunen wrote:
> Add host1x, disp1 and disp2 clocks to the clock initialization table.
> These clocks are required for HDMI support.

This patch should be sent to Mike Turquette so it can be taken through
the clock tree.
