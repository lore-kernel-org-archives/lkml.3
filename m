Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaK0P03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:26:29 -0500
Received: from kazi.fit.vutbr.cz ([147.229.8.12]:47522 "EHLO kazi.fit.vutbr.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbaK0P02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:26:28 -0500
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Nov 2014 10:26:27 EST
Date: Thu, 27 Nov 2014 16:17:41 +0100
From: Tomas Novotny <tomas@novotny.cz>
To: rtc-linux@googlegroups.com
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, grant.likely@linaro.org,
        robh+dt@kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/4] rtc: ds1307: add support for device tree and
 mcp7940x
Message-ID: <20141127161741.52e8d300@tomas>
In-Reply-To: <1416844164-16782-1-git-send-email-tomas@novotny.cz>
References: <1416844164-16782-1-git-send-email-tomas@novotny.cz>
X-Mailer: Claws Mail 3.11.0 (GTK+ 2.24.25; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014 16:49:20 +0100
Tomas Novotny <tomas@novotny.cz> wrote:

> This series is tested with MCP79401 and it is based on 3.18-rc6.
> 
> Tomas Novotny (4):
>   rtc: ds1307: add support for mcp7940x chips
>   of: add vendor prefix for Pericom Technology
>   rtc: ds1307: add device tree bindings documentation
>   rtc: ds1307: add device tree support
> 
>  .../devicetree/bindings/rtc/maxim,ds1307.txt       |  23 ++++
>  .../devicetree/bindings/vendor-prefixes.txt        |   1 +
>  drivers/rtc/rtc-ds1307.c                           | 149 ++++++++++++---------
>  3 files changed, 110 insertions(+), 63 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/rtc/maxim,ds1307.txt

It is now in the -mm and linux-next.
Thanks to Andrew for pick up,

Tomas
