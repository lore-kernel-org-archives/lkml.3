Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981AbaHEJY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 05:24:29 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:48347 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096AbaHEJY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 05:24:28 -0400
Date: Tue, 5 Aug 2014 10:23:46 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: David Airlie <airlied@linux.ie>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/gma500: mdfld: Reuse video/mipi_display.h
Message-ID: <20140805102346.67867256@alan.etchedpixels.co.uk>
In-Reply-To: <1407220036-4058-1-git-send-email-thierry.reding@gmail.com>
References: <1407220036-4058-1-git-send-email-thierry.reding@gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  5 Aug 2014 08:27:16 +0200
Thierry Reding <thierry.reding@gmail.com> wrote:

> From: Thierry Reding <treding@nvidia.com>
> 
> The GMA500 driver redefines many constants already found in the generic
> header. Replace uses of the custom defines by the standard ones and get
> rid of the duplicate defininitions.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

The driver pre-dates the standard ones I think. Looks good thanks for
the cleanup

Acked-by: Alan Cox <alan@linux.intel.com>
