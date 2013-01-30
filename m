Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab3A3RFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 12:05:42 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37305 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab3A3RFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 12:05:37 -0500
Message-ID: <510952DE.70905@wwwdotorg.org>
Date: Wed, 30 Jan 2013 10:05:34 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] drm: avoid "mono_time_offset may be used uninitialized"
References: <1359504590-23517-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1359504590-23517-1-git-send-email-swarren@wwwdotorg.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 05:09 PM, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Silence the following:
> drivers/gpu/drm/drm_irq.c: In function 'drm_calc_vbltimestamp_from_scanoutpos':
> drivers/gpu/drm/drm_irq.c:583:24: warning: 'mono_time_offset.tv64' may be used uninitialized in this function

FYI, I found that I see this warning with gcc-4.5.3, but not with
gcc-4.7.2 or gcc-4.6.3. Hence, you might decide you don't care about
this patch.
