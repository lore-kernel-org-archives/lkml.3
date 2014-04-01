Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaDATmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 15:42:42 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:62715 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751233AbaDATmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 15:42:40 -0400
Message-ID: <1396381357.23763.16.camel@x220>
Subject: Re: [git pull] Devicetree changes for v3.15
From: Paul Bolle <pebolle@tiscali.nl>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@linaro.org>
Date: Tue, 01 Apr 2014 21:42:37 +0200
In-Reply-To: <CACxGe6vCrkHPL6UNy1p8AO4+z5VFRY6w4_2grQEZQwp_3jJ7Yw@mail.gmail.com>
References: <CACxGe6vCrkHPL6UNy1p8AO4+z5VFRY6w4_2grQEZQwp_3jJ7Yw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2014 19:42:38.0413 (UTC) FILETIME=[89A2CFD0:01CF4DE2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-01 at 11:15 +0100, Grant Likely wrote:
> Grant Likely (13):
>       [...]
>       of: remove /proc/device-tree

That commit leaves a select for PROC_DEVICETREE dangling. See "config
ARCH_OMAP2PLUS" in arch/arm/mach-omap2/Kconfig. Can that select
statement just be dropped now or is something more elaborate needed?


Paul Bolle

