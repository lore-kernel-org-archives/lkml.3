Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbaGCNQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:16:44 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50303 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755603AbaGCNQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:16:41 -0400
Date: Thu, 3 Jul 2014 15:16:37 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, David Airlie <airlied@linux.ie>,
        Randy Dunlap <rdunlap@infradead.org>, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] drm/panel: add support for Foxlink FL500WVR00-A0T
 panel
Message-ID: <20140703151637.664c4f49@bbrezillon>
In-Reply-To: <1401976412-27436-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1401976412-27436-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thierry,

I haven't had any feedback from you on this pretty straightforward
patch series adding support for a new LCD panel.

Did you receive it in the first place ?

Best Regards,

Boris

On Thu,  5 Jun 2014 15:53:30 +0200
Boris BREZILLON <boris.brezillon@free-electrons.com> wrote:

> Hello,
> 
> This series adds a new entry in the vendor-prefixes.txt file for Foxlink
> Group and defines Foxlink FL500WVR00-A0T panel specifications in the simple
> panel driver.
> 
> Best Regards,
> 
> Boris
> 
> 
> Boris BREZILLON (2):
>   DT: add vendor prefix for Foxlink Group
>   drm/panel: add support for Foxlink FL500WVR00-A0T panel
> 
>  .../bindings/panel/foxlink,fl500wvr00-a0t.txt      |  7 ++++++
>  .../devicetree/bindings/vendor-prefixes.txt        |  1 +
>  drivers/gpu/drm/panel/panel-simple.c               | 25 ++++++++++++++++++++++
>  3 files changed, 33 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/panel/foxlink,fl500wvr00-a0t.txt
> 



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
