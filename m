Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbaJOS42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 14:56:28 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:39273 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbaJOS4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 14:56:25 -0400
MIME-Version: 1.0
In-Reply-To: <1413399256.2412.27.camel@jtkirshe-mobl>
References: <1413375999-10210-1-git-send-email-jeffrey.t.kirsher@intel.com>
	<20141015123431.GA23154@mwanda>
	<20141015125934.GB23154@mwanda>
	<1413378213.2412.13.camel@jtkirshe-mobl>
	<1413389496.7484.3.camel@perches.com>
	<1413394958.2412.23.camel@jtkirshe-mobl>
	<CAOMZO5C5ya=OgBUEOOM+tZE7B2zZ3J05PHC14t3Tp6nXkPYmoQ@mail.gmail.com>
	<1413399256.2412.27.camel@jtkirshe-mobl>
Date: Wed, 15 Oct 2014 15:56:23 -0300
Message-ID: <CAOMZO5Ac6dA4P8UaDotBR5peUSfe8DVUPVQt_1u9EUZXv0uOVA@mail.gmail.com>
Subject: Re: [PATCH] bcm/CmHost.c: Fix noisy compile warnings
From: Fabio Estevam <festevam@gmail.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 3:54 PM, Jeff Kirsher
<jeffrey.t.kirsher@intel.com> wrote:
> On Wed, 2014-10-15 at 15:24 -0300, Fabio Estevam wrote:
>> On Wed, Oct 15, 2014 at 2:42 PM, Jeff Kirsher
>> <jeffrey.t.kirsher@intel.com> wrote:
>>
>> > I like the idea, but won't this exclude other 32 bit systems like MIPS
>> > and I am sure there might be others.  I could assume that Beceem WIMAX
>> > was intended for x86 arch's that are 32 bit only, which may be a safe
>> > bet.  The only thing we know for sure is that is broken on 64bit.
>>
>> What about this?
>
> That works for me.  I am putting together a v2 patch now, since you came
> up with the change, I will put you as the author Fabio, ok?

That's OK, Jeff.

Please use: Fabio Estevam <fabio.estevam@freescale.com>

Thanks
