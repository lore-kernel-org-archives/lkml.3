Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaG1SCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 14:02:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58249 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbaG1SCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 14:02:31 -0400
Message-ID: <53D69034.6080302@suse.de>
Date: Mon, 28 Jul 2014 20:02:28 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: linux-tegra@vger.kernel.org, thierry.reding@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Update Tegra Git URL
References: <1406568643-2047-1-git-send-email-afaerber@suse.de> <53D68F5F.6050109@wwwdotorg.org>
In-Reply-To: <53D68F5F.6050109@wwwdotorg.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 28.07.2014 19:58, schrieb Stephen Warren:
> On 07/28/2014 11:30 AM, Andreas Färber wrote:
>> swarren/linux-tegra.git does not exist, it's tegra/linux.git.
> 
> FWIW, there is a redirect in place, so "git clone" on the old URL works
> fine. Still, we should indeed update the MAINTAINERS entry to point at
> the correct location.

http://git.kernel.org/cgit/linux/kernel/git/swarren/linux-tegra.git does
not redirect unfortunately.

> I'll forward this on to arm@kernel.org to be applied.

Feel free to edit the commit message to your liking.

Thanks,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
