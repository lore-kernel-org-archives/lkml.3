Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab3HTQmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:42:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45017 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab3HTQm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:42:29 -0400
Message-ID: <52139BC3.8030907@ti.com>
Date: Tue, 20 Aug 2013 19:39:31 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Hein Tibosch <hein_tibosch@yahoo.es>, <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-omap: always send stop after nack
References: <51E50217.1000507@yahoo.es> <20130716090300.GG8880@arwen.pp.htv.fi> <51E5137B.7000302@yahoo.es> <20130716094212.GL8880@arwen.pp.htv.fi> <51E527F7.4080007@ti.com> <20130716112746.GN8880@arwen.pp.htv.fi> <51E537A4.40300@ti.com> <20130716130058.GD15036@arwen.pp.htv.fi> <51E57211.2040001@yahoo.es> <20130819121123.GA4540@katana>
In-Reply-To: <20130819121123.GA4540@katana>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2013 03:11 PM, Wolfram Sang wrote:
> Hi,
>
>>> Which means your original patch starts to make a lot more sense. I
>>> wonder is this is really what we should be doing though - breaking out
>>> of the loop, I mean.
>
> Yup, that is fine. I applied the old patch with Acks from Hein and
> Felipe to -next. Thanks!

Thanks.

>
>> It looks like TI's i2c-davinci will have the same problem as i2c-omap,
>> and will need the same change.
>
> Somebody up for this?
>

Regards,
-grygorii
