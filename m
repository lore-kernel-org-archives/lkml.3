Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab3COTXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:23:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53445 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab3COTXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:23:40 -0400
Message-ID: <51437526.2050001@wwwdotorg.org>
Date: Fri, 15 Mar 2013 13:23:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: linux-tegra@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] memory: tegra30: Fix build error w/o PM
References: <1363252334-4672-1-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1363252334-4672-1-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 03:12 AM, Hiroshi Doyu wrote:
> Make this depend on CONFIG_PM.

Applied to Tegra's for-3.10/fixes branch.
