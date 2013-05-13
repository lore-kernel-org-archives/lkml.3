Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab3EMHMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 03:12:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:64291 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630Ab3EMHMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 03:12:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,659,1363158000"; 
   d="scan'208";a="301534365"
Message-ID: <1368429308.5360.6.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: devices: added the 16mb winbond device
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: girishks2000@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, Girish K S <ks.giri@samsung.com>
Date: Mon, 13 May 2013 10:15:08 +0300
In-Reply-To: <516d0c68.e10b420a.287d.ffff894c@mx.google.com>
References: <516d0c68.e10b420a.287d.ffff894c@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-16 at 14:01 +0530, girishks2000@gmail.com wrote:
> From: Girish K S <ks.giri@samsung.com>
> 
> added a 16mb winbond devce to the device list
> erase size = 64k and number of blocks = 256
> 
> Signed-off-by: Girish K S <ks.giri@samsung.com>

Pushed to l2-mtd.git, but please, remember to use better suffixes. E.g.,
mb may mean mega bytes, or mega bits. 16MiB device, 64KiB block size is
a lot less ambiguous way communicate the sizes.

I've amended your commit message.

-- 
Best Regards,
Artem Bityutskiy

