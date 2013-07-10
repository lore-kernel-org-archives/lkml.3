Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab3GJMnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 08:43:52 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:41519 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab3GJMnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 08:43:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130710122523.GA357@x4>
References: <20130709.145325.1363244885668360965.davem@davemloft.net>
	<20130710122523.GA357@x4>
Date: Wed, 10 Jul 2013 08:43:50 -0400
Message-ID: <CA+5PVA5AT0OLNi-=x91ks5AbigymE3BDmdoEiiNOeRoGFCFQfg@mail.gmail.com>
Subject: Re: [GIT] Networking
From: Josh Boyer <jwboyer@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 8:25 AM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
> On 2013.07.09 at 14:53 -0700, David Miller wrote:
>>
>> Alexey Brodkin (2):
>>       ethernet/arc/arc_emac - Add new driver
>>       arc_emac: fix compile-time errors & warnings on PPC64
>
> This driver defaults to y for no reason:
>
> +config NET_VENDOR_ARC
> +       bool "ARC devices"
> +       default y

That's the option to enable the ARC vendor, not the driver.  The
driver config option is ARC_EMAC.  All of the other ethernet vendors
also default to y, so I don't think this is out of line.

josh
