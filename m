Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab3K1DUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 22:20:24 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:34119 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118Ab3K1DUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 22:20:21 -0500
Date: Thu, 28 Nov 2013 05:20:18 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Eunbong Song <eunb.song@samsung.com>
Cc: linux@arm.linux.org.uk, "tony@atomide.com" <tony@atomide.com>,
        linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM : Kill CONFIG_MTD_PARTITIONS
Message-ID: <20131128032018.GO32436@tarshish>
References: <15408127.286411385601524346.JavaMail.weblogic@epv6ml06>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15408127.286411385601524346.JavaMail.weblogic@epv6ml06>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eunbong,

On Thu, Nov 28, 2013 at 01:18:45AM +0000, Eunbong Song wrote:
> This patch removes CONFIG_MTD_PARTITIONS in config files for arm.
> Because CONFIG_MTD_PARTITIONS was removed by commit 6a8a98b22b10f1560d5f90aded4a54234b9b2724.
> ---
> I resend this patch because i forgot signoff.

Well, it seems you forgot it again.

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
