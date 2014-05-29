Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934797AbaE2RwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:52:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45973 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932640AbaE2RwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:52:03 -0400
Message-ID: <538773C0.30906@wwwdotorg.org>
Date: Thu, 29 May 2014 11:52:00 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 0/2] debugfs entries for Tegra clocks
References: <1401295868-18697-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1401295868-18697-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 10:51 AM, Peter De Schrijver wrote:
> This patch set introduces the 'regs' debugfs entry which shows the
> contents of all registers related to a clock.

Would it be better to create a regmap object for the entire clock module
register space, and then get all the debugfs stuff for free?
