Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab3FQVFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 17:05:05 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:63801 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753673Ab3FQVFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 17:05:03 -0400
Message-ID: <1371503099.26299.27.camel@x61.thuisdomein>
Subject: Re: [PATCH] drm/tegra: Include linux/types.h
From: Paul Bolle <pebolle@tiscali.nl>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Stephen Warren <swarren@wwwdotorg.org>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Date: Mon, 17 Jun 2013 23:04:59 +0200
In-Reply-To: <20130617203353.GC5265@mithrandir>
References: <1371470294.26299.21.camel@x61.thuisdomein>
	 <20130617203353.GC5265@mithrandir>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jun 2013 21:05:00.0892 (UTC) FILETIME=[549D41C0:01CE6B9E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-17 at 22:33 +0200, Thierry Reding wrote:
> That has already been fixed in linux-next.

This header was added in v3.10-rc1. The fix in linux-next will ship in
v3.11. Isn't that fix appropriate for (one of) the upcoming v3.10
release candidate(s)?

Thanks,


Paul Bolle

