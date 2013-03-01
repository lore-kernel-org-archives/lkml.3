Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab3CABrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 20:47:16 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33966 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3CABrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 20:47:14 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:fd1c:10bb:eed2:5df8:1c8f]
In-Reply-To: <CAGo_u6qZwgGOugh3_F2pFvwM8ZAxU=Rsy7B2Lj6CjO+VG7GwXA@mail.gmail.com>
References: <1358890049-26981-1-git-send-email-nm@ti.com>
	<5108BDDD.60307@ti.com>
	<CAGo_u6qZwgGOugh3_F2pFvwM8ZAxU=Rsy7B2Lj6CjO+VG7GwXA@mail.gmail.com>
Date: Thu, 28 Feb 2013 17:47:13 -0800
Message-ID: <CAOesGMgZ4VPnkn7ZuNPYeA9fv=ACwXy8-wr6L3ttVfPkRjaZnw@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: remove generated .dtb files on clean
From: Olof Johansson <olof@lixom.net>
To: Nishanth Menon <nm@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        l-a <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 5:35 PM, Nishanth Menon <nm@ti.com> wrote:
> On Wed, Jan 30, 2013 at 12:29 AM, Santosh Shilimkar
> <santosh.shilimkar@ti.com> wrote:
>> Looping RMK, Arnd
> Gentle query if we are still interested in this:
> https://patchwork.kernel.org/patch/2020831/
>
> Looks like linux master still wont delete the dtbs on make clean etc..
> I think leaving the stale dtbs
> around could have it's set of user errors.

Applied to arm-soc fixes for 3.9.


-Olof
