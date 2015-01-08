Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbbAHJdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 04:33:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49726 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755390AbbAHJdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 04:33:16 -0500
Date: Thu, 8 Jan 2015 09:33:13 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Inha Song <ideal.song@samsung.com>
Cc: broonie@kernel.org, lgirdwood@gmail.com, lee.jones@linaro.org,
        sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] [RESEND PATCH] mfd: wm8994: set mfd id-base for
	regulator devs creation to avoid conflicts
Message-ID: <20150108093313.GT14516@opensource.wolfsonmicro.com>
References: <1420679073-3316-1-git-send-email-ideal.song@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420679073-3316-1-git-send-email-ideal.song@samsung.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 10:04:33AM +0900, Inha Song wrote:
> After commit: 6e3f62f0793e ("mfd: core: Fix platform-device id generation")
> We must set the id base when register a duplicate name of mfd_cell.
> If not, duplicate filename error was reported.
> 
> - sysfs: cannot create duplicate filename '/devices/.../wm8994-ldo'
> 
> Signed-off-by: Inha Song <ideal.song@samsung.com>
> ---

Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Thanks,
Charles
