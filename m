Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764459Ab3DDSTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 14:19:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53877 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764443Ab3DDSTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 14:19:02 -0400
Message-ID: <515DC413.8050600@wwwdotorg.org>
Date: Thu, 04 Apr 2013 12:18:59 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: Add missing cdev1 and cdev2 clocks
References: <1365066333-2361-1-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1365066333-2361-1-git-send-email-pgaikwad@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 03:05 AM, Prashant Gaikwad wrote:
> Register cdev1 and cdev2 peripheral clocks.

Can you please explain the relationship between the following clocks:

cdev1
extern1
clk_out1

The latter two clocks already exist in this driver. I think that
clk_out1 is meant to represent cdev1 already, although it's set up to
point at some PMC registers, rather than the CAR CLK_ENB registers.
