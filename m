Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab3EaXfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 19:35:14 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:39769 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab3EaXfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 19:35:08 -0400
Date: Sat, 1 Jun 2013 02:34:58 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, Ben Skeggs <bskeggs@redhat.com>,
        patches@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 03/15] drm/nouveau: use mdelay instead of large udelay
 constants
Message-ID: <20130531233458.GD3345@blackmetal.musicnaut.iki.fi>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
 <1370038972-2318779-4-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370038972-2318779-4-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jun 01, 2013 at 12:22:40AM +0200, Arnd Bergmann wrote:
> ARM cannot handle udelay for more than 2 miliseconds, so we
                                           ^^^^

                                 There's l missing here.

> should use mdelay instead for those.

Could this be handled inside ARM udelay() instead? Probably most of the
delay values are compile-time constants.

A.
