Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765406Ab3DDX17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 19:27:59 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56445 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762949Ab3DDX16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 19:27:58 -0400
Message-ID: <515E0C7B.6090005@wwwdotorg.org>
Date: Thu, 04 Apr 2013 17:27:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: Fix cdev1 and cdev2 IDs
References: <1365066304-2327-1-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1365066304-2327-1-git-send-email-pgaikwad@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 03:05 AM, Prashant Gaikwad wrote:
> Correct IDs for cdev1 and cdev2 are 94 and 93 respectively.

I've applied this, split into the two patches I just posted.
