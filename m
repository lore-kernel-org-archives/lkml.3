Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab3COTRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:17:01 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41800 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab3COTQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:16:59 -0400
Message-ID: <514373A8.2080807@wwwdotorg.org>
Date: Fri, 15 Mar 2013 13:16:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Danny Huang <dahuang@nvidia.com>
CC: linux@arm.linux.org.uk, ldewangan@nvidia.com, olof@lixom.net,
        hdoyu@nvidia.com, thierry.reding@avionic-design.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v4] ARM: tegra: expose chip ID and revision
References: <1363222120-22210-1-git-send-email-dahuang@nvidia.com>
In-Reply-To: <1363222120-22210-1-git-send-email-dahuang@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2013 06:48 PM, Danny Huang wrote:
> Expose Tegra chip ID and revision in /sys/devices/soc for user mode
> usage

Applied to Tegra's for-3.10/soc branch.
