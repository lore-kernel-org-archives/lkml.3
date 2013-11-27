Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab3K0Toj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 14:44:39 -0500
Received: from mail-qe0-f53.google.com ([209.85.128.53]:61840 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab3K0Tog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 14:44:36 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <CAPcyv4js+Hq+b8g1i65NE8iK-BnXjG9Bi3PuPpWXRss19-Z9Jg@mail.gmail.com>
References: <1385528004-19423-1-git-send-email-olof@lixom.net>
	<CAPcyv4js+Hq+b8g1i65NE8iK-BnXjG9Bi3PuPpWXRss19-Z9Jg@mail.gmail.com>
Date: Wed, 27 Nov 2013 11:44:35 -0800
Message-ID: <CAOesGMhOWgZO7k=Xd-Qafp8Q+Z-zw4x=j=1Tk+EGBSTXjzTD_A@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: pl08x: fix conversioin for generic unmap data
From: Olof Johansson <olof@lixom.net>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 11:38 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> Thanks, Olof I'll push this shortly.  I'll add your acked-by to this
> one from Russell.
>
> https://patchwork.kernel.org/patch/3241941/

Sure, sounds good. I've posted a couple more as well (the at_hdmac one
I posted yesterday) and "[PATCH] dma: mv_xor: remove
mv_desc_get_dest_addr()" from Jason Cooper.


-Olof
