Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaESI3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:29:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37885 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753424AbaESI3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:29:44 -0400
Date: Mon, 19 May 2014 09:29:42 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Mark Brown <broonie@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Carlo Caione <carlo@caione.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 3/3] arizona-mfd-codecs: Add
	mfd_register_supply_aliases() calls
Message-ID: <20140519082942.GR25203@opensource.wolfsonmicro.com>
References: <1400420953-20705-1-git-send-email-hdegoede@redhat.com> <1400420953-20705-4-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400420953-20705-4-git-send-email-hdegoede@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2014 at 03:49:13PM +0200, Hans de Goede wrote:
> The mfd-core no longer registers the supply aliases, instead the platform
> driver probe method must now call mfd_register_supply_aliases().
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---

Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Thanks,
Charles
