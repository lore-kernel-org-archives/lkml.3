Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934868Ab3DHRWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:22:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:52172 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934224Ab3DHRWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:22:47 -0400
Message-ID: <5162FCE0.6090900@infradead.org>
Date: Mon, 08 Apr 2013 10:22:40 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: linux-kernel@vger.kernel.org, trivial@kernel.org, joe@perches.com
Subject: Re: [PATCH/v2] [trivial]treewide: Fix typo in printks
References: <1365440810-25964-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1365440810-25964-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/13 10:06, Masanari Iida wrote:
> Correct spelling typos in printk and comments.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.


> 
> ---
>  drivers/media/pci/saa7164/saa7164-core.c | 2 +-
>  drivers/rtc/Kconfig                      | 4 ++--
>  drivers/rtc/rtc-max8997.c                | 2 +-
>  drivers/usb/misc/iowarrior.c             | 4 ++--
>  drivers/usb/misc/uss720.c                | 2 +-
>  drivers/video/amifb.c                    | 2 +-
>  drivers/video/auo_k190x.c                | 2 +-
>  drivers/video/goldfishfb.c               | 2 +-
>  drivers/video/s1d13xxxfb.c               | 2 +-
>  drivers/video/ssd1307fb.c                | 4 ++--
>  fs/nfs/objlayout/objio_osd.c             | 2 +-
>  fs/nfs/objlayout/objlayout.h             | 2 +-
>  sound/soc/codecs/wm8974.c                | 2 +-
>  tools/perf/tests/attr.c                  | 2 +-
>  tools/perf/tests/parse-events.c          | 2 +-
>  15 files changed, 18 insertions(+), 18 deletions(-)



-- 
~Randy
