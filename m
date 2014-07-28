Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbaG1R67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:58:59 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38457 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaG1R64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:58:56 -0400
Message-ID: <53D68F5F.6050109@wwwdotorg.org>
Date: Mon, 28 Jul 2014 11:58:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
CC: linux-tegra@vger.kernel.org, thierry.reding@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Update Tegra Git URL
References: <1406568643-2047-1-git-send-email-afaerber@suse.de>
In-Reply-To: <1406568643-2047-1-git-send-email-afaerber@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2014 11:30 AM, Andreas Färber wrote:
> swarren/linux-tegra.git does not exist, it's tegra/linux.git.

FWIW, there is a redirect in place, so "git clone" on the old URL works 
fine. Still, we should indeed update the MAINTAINERS entry to point at 
the correct location.

I'll forward this on to arm@kernel.org to be applied.
