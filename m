Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab3DZPT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:19:56 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60041 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3DZPTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:19:55 -0400
Date: Fri, 26 Apr 2013 16:19:48 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mian.yousaf.kaukab@stericsson.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 00/10] usb: musb: ux500: pathe the way for Device Tree
 enablement
Message-ID: <20130426151948.GE31899@gmail.com>
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
 <20130426134915.GA19558@balto.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130426134915.GA19558@balto.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Apr 2013, Fabio Baltieri wrote:

> Hi Lee,
> 
> On Tue, Apr 23, 2013 at 04:03:04PM +0100, Lee Jones wrote:
> > In this patch-set we firstly ease the burden on data being passed from
> > platform data, then start to build up support to finally enable Device
> > Tree.
> 
> The whole series looks good to me, nice job!!
> 
> Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>

Thanks for reviewing.

> I was not able to apply the patches though, as I can imagine that there
> are some dependencies with your other dma40 series.  If you can provide a
> tree I would be happy to run some test for both host and device mode.
> I still have a bunch of USB cables and adapters tangled together on my
> desk ready for that.

The most recent branch on my public tree contains the latest code.

Memcpy will probably fail though, as I haven't fixed up Linus'
comments pertaining them that yet.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
