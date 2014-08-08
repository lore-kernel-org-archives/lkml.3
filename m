Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383AbaHHUDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:03:33 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:45203 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaHHUDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:03:32 -0400
MIME-Version: 1.0
In-Reply-To: <1407516479-1251-1-git-send-email-olof@lixom.net>
References: <1407516479-1251-1-git-send-email-olof@lixom.net>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 8 Aug 2014 15:03:11 -0500
Message-ID: <CAL_JsqLgRM8_62mz3HCcsE6vw0gtB3pN0rg6SExnZvnOTRNu2g@mail.gmail.com>
Subject: Re: [GIT PULL 0/7] ARM: SoC changes for 3.17
To: Olof Johansson <olof@lixom.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2014 at 11:47 AM, Olof Johansson <olof@lixom.net> wrote:
> A moderately sized set of branches this merge window for us, about 750
> patches in total. There are several fairly large cleanups, and a net
> negative delta(!)
>
>  1014 files changed, 39452 insertions(+), 42425 deletions(-)

If you look at mach-* and plat-* only, the overall delta has been
negative mostly since 3.0 which was when ARM DT support went in. The
overall size is trending down as well after growing by an order of
magnitude. You're going to be out of a job soon (or DTS maintainer).
;)

v2.6.12: 104 files changed, 3896 insertions(+), 1001 deletions(-)
v2.6.13: 153 files changed, 4160 insertions(+), 2033 deletions(-)
v2.6.14: 125 files changed, 4048 insertions(+), 924 deletions(-)
v2.6.15: 178 files changed, 15850 insertions(+), 2666 deletions(-)
v2.6.16: 179 files changed, 3741 insertions(+), 2338 deletions(-)
v2.6.17: 151 files changed, 9469 insertions(+), 1646 deletions(-)
v2.6.18: 293 files changed, 14782 insertions(+), 2056 deletions(-)
v2.6.19: 228 files changed, 5906 insertions(+), 4286 deletions(-)
v2.6.20: 159 files changed, 7002 insertions(+), 646 deletions(-)
v2.6.21: 193 files changed, 17596 insertions(+), 5574 deletions(-)
v2.6.22: 238 files changed, 8694 insertions(+), 1364 deletions(-)
v2.6.23: 143 files changed, 4811 insertions(+), 849 deletions(-)
v2.6.24: 139 files changed, 7448 insertions(+), 1038 deletions(-)
v2.6.25: 238 files changed, 18425 insertions(+), 3397 deletions(-)
v2.6.26: 225 files changed, 19606 insertions(+), 8390 deletions(-)
v2.6.27: 1384 files changed, 90110 insertions(+), 5576 deletions(-)
v2.6.28: 640 files changed, 21783 insertions(+), 5853 deletions(-)
v2.6.29: 724 files changed, 24235 insertions(+), 8258 deletions(-)
v2.6.30: 678 files changed, 31267 insertions(+), 12506 deletions(-)
v2.6.31: 685 files changed, 49529 insertions(+), 10099 deletions(-)
v2.6.32: 698 files changed, 59564 insertions(+), 5593 deletions(-)
v2.6.33: 835 files changed, 50995 insertions(+), 16124 deletions(-)
v2.6.34: 1059 files changed, 56064 insertions(+), 16620 deletions(-)
v2.6.35: 797 files changed, 44051 insertions(+), 11856 deletions(-)
v2.6.36: 871 files changed, 43841 insertions(+), 13222 deletions(-)
v2.6.37: 1126 files changed, 48471 insertions(+), 12067 deletions(-)
v2.6.38: 1055 files changed, 60061 insertions(+), 17964 deletions(-)
v2.6.39: 1223 files changed, 52552 insertions(+), 23067 deletions(-)
v3.0: 833 files changed, 10945 insertions(+), 37476 deletions(-)
v3.1: 955 files changed, 17796 insertions(+), 20300 deletions(-)
v3.2: 1507 files changed, 32960 insertions(+), 33392 deletions(-)
v3.3: 1301 files changed, 27725 insertions(+), 18941 deletions(-)
v3.4: 1324 files changed, 27079 insertions(+), 21500 deletions(-)
v3.5: 975 files changed, 32340 insertions(+), 46663 deletions(-)
v3.6: 648 files changed, 16121 insertions(+), 13161 deletions(-)
v3.7: 1389 files changed, 23739 insertions(+), 61097 deletions(-)
v3.8: 1066 files changed, 32812 insertions(+), 40821 deletions(-)
v3.9: 1031 files changed, 10051 insertions(+), 33399 deletions(-)
v3.10: 831 files changed, 15049 insertions(+), 27333 deletions(-)
v3.11: 675 files changed, 18519 insertions(+), 30012 deletions(-)
v3.12: 474 files changed, 12575 insertions(+), 25120 deletions(-)
v3.13: 491 files changed, 11088 insertions(+), 13375 deletions(-)
v3.14: 408 files changed, 5586 insertions(+), 12691 deletions(-)
v3.15: 538 files changed, 7809 insertions(+), 9337 deletions(-)
v3.16: 499 files changed, 6528 insertions(+), 10252 deletions(-)

Rob
