Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbbAVS6F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:58:05 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:60094 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbbAVS54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:57:56 -0500
Date: Thu, 22 Jan 2015 16:57:50 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/36] drm/plane: Add optional ->atomic_disable() callback
Message-ID: <20150122185750.GJ2001@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Thierry Reding <thierry.reding@gmail.com>,
	dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
 <1421750935-4023-4-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421750935-4023-4-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-20 Thierry Reding <thierry.reding@gmail.com>:

> From: Thierry Reding <treding@nvidia.com>
> 
> In order to prevent drivers from having to perform the same checks over
> and over again, add an optional ->atomic_disable callback which the core
> calls under the right circumstances.
> 
> v2: pass old state and detect edges to avoid calling ->atomic_disable on
> already disabled planes, remove redundant comment (Daniel Vetter)
> 
> v3: rename helper to drm_atomic_plane_disabling() to clarify that it is
> checking for transitions, move helper to drm_atomic_helper.h, clarify
> check for !old_state and its relation to transitional helpers
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/gpu/drm/drm_atomic_helper.c |  9 ++++++++-
>  drivers/gpu/drm/drm_plane_helper.c  | 10 +++++++++-
>  include/drm/drm_atomic_helper.h     | 37 +++++++++++++++++++++++++++++++++++++
>  include/drm/drm_plane_helper.h      |  3 +++
>  4 files changed, 57 insertions(+), 2 deletions(-)

Reviewed-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>

	Gustavo
