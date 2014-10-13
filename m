Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaJMM0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 08:26:17 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:65197 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbaJMM0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 08:26:14 -0400
Message-ID: <1413203171.9362.81.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: Regarding tx-nocache-copy in the Sheevaplug
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Carles =?ISO-8859-1?Q?Pag=E8s?= <page@cubata.homelinux.net>,
        linux-arm-kernel@lists.infradead.org
Date: Mon, 13 Oct 2014 05:26:11 -0700
In-Reply-To: <20141013105246.GD1972@vicerveza.homeunix.net>
References: <20141013105246.GD1972@vicerveza.homeunix.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-13 at 12:52 +0200, Lluís Batlle i Rossell wrote:
> Hello,
> 
> on the 7th of January 2014 ths patch was applied:
> https://lkml.org/lkml/2014/1/7/307
> 
> [PATCH v2] net: Do not enable tx-nocache-copy by default
>         
> In the Sheevaplug (ARM Feroceon 88FR131 from Marvell) this made packets to be
> sent corrupted. I think this machine has something special about the cache.
> 
> Enabling back this tx-nocache-copy (as it used to be before the patch) the
> transfers work fine again. I think that most people, encountering this problem,
> completely disable the tx offload instead of enabling back this setting.
> 
> Is this an ARM kernel problem regarding this platform?

Which NIC and driver is this exactly ?



