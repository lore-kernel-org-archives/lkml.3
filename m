Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbaIIP6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:58:51 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:54641 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaIIP6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:58:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/8] Documentation: bindings: net: add the Marvell PXA168 Ethernet controller
Date: Tue, 09 Sep 2014 17:58:12 +0200
Message-ID: <3827594.chb831jyvc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1410273848-24663-4-git-send-email-antoine.tenart@free-electrons.com>
References: <1410273848-24663-1-git-send-email-antoine.tenart@free-electrons.com> <1410273848-24663-4-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:i1FVmvgCg/J6kHjy43O5s5VYVXsHoirHQT63M50PrWf
 fZqMm4tRu+ZD8dwvO8rejthQKrHiSnILKavie08NrjcYV1Me8K
 eqaMhIMB0PPkffS+DgoSzlMN2C5wgxq/gPTah5WQ19L2enb/F7
 HMUIBKWzhRNAAs7Kxkop+IQRgxJl+u3/baRf1x9jqHbiPL4zca
 Tv77vNQWUrc4NvzkKlQPUDRWTC8gC8JqbLhEAm7DTc/2Ibz3OJ
 etyrKszs5D/iqOdF5eRlTut0hOix8qh6fBu/VUpa+HtbY507AP
 lwNEE6Z9hSYfaFCV8xT6JwJE5N5I1LI5GbfJn1HpLy5K86Uc5W
 +MZ3jYINvUT52BCigDYw=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2014 16:44:03 Antoine Tenart wrote:
> +- clocks: pointer to the clock for the device.
> +- clock-names: should be "MFUCLK".

Clock names are normally not capitalized. Are you able to change
that name when providing a binding or make it an anoymous clock?
What does MFU stand for anyway?

	Arnd
