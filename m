Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab3DZNt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 09:49:29 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:41873 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab3DZNt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 09:49:27 -0400
Date: Fri, 26 Apr 2013 15:49:15 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mian.yousaf.kaukab@stericsson.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 00/10] usb: musb: ux500: pathe the way for Device Tree
 enablement
Message-ID: <20130426134915.GA19558@balto.lan>
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
X-Operating-System: Linux balto 3.9.0-rc8 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Tue, Apr 23, 2013 at 04:03:04PM +0100, Lee Jones wrote:
> In this patch-set we firstly ease the burden on data being passed from
> platform data, then start to build up support to finally enable Device
> Tree.

The whole series looks good to me, nice job!!

Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>

I was not able to apply the patches though, as I can imagine that there
are some dependencies with your other dma40 series.  If you can provide a
tree I would be happy to run some test for both host and device mode.
I still have a bunch of USB cables and adapters tangled together on my
desk ready for that.

Fabio

-- 
Fabio Baltieri
