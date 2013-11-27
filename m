Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab3K0TtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 14:49:17 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:43353 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab3K0TtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 14:49:14 -0500
MIME-Version: 1.0
In-Reply-To: <CAOesGMhOWgZO7k=Xd-Qafp8Q+Z-zw4x=j=1Tk+EGBSTXjzTD_A@mail.gmail.com>
References: <1385528004-19423-1-git-send-email-olof@lixom.net>
	<CAPcyv4js+Hq+b8g1i65NE8iK-BnXjG9Bi3PuPpWXRss19-Z9Jg@mail.gmail.com>
	<CAOesGMhOWgZO7k=Xd-Qafp8Q+Z-zw4x=j=1Tk+EGBSTXjzTD_A@mail.gmail.com>
Date: Wed, 27 Nov 2013 11:49:13 -0800
Message-ID: <CAPcyv4gsBZnttgbOHdaAY1h5Tw=Zkgr2r3dSKx+C6H3jurjcvg@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: pl08x: fix conversioin for generic unmap data
From: Dan Williams <dan.j.williams@intel.com>
To: Olof Johansson <olof@lixom.net>
Cc: Vinod Koul <vinod.koul@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 11:44 AM, Olof Johansson <olof@lixom.net> wrote:
> On Wed, Nov 27, 2013 at 11:38 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>> Thanks, Olof I'll push this shortly.  I'll add your acked-by to this
>> one from Russell.
>>
>> https://patchwork.kernel.org/patch/3241941/
>
> Sure, sounds good. I've posted a couple more as well (the at_hdmac one
> I posted yesterday) and "[PATCH] dma: mv_xor: remove
> mv_desc_get_dest_addr()" from Jason Cooper.
>

Yup, those are in the patchwork queue, just waiting on my test build
to tell me there aren't any others.
