Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab3CDUeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 15:34:50 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:54251 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab3CDUes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 15:34:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: Latest randconfig build errors
Date: Mon, 4 Mar 2013 20:34:43 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, arm@kernel.org,
        linux-kernel@vger.kernel.org
References: <20130304095136.GI17833@n2100.arm.linux.org.uk>
In-Reply-To: <20130304095136.GI17833@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303042034.43833.arnd@arndb.de>
X-Provags-ID: V02:K0:UgjbgQ1Cjm2+1g39phYkp2QWE8NzqO/VGSJScWTXGvB
 he6Qm/2T0pwfCmy8pZUNeWyFS/hI0y192/pGkX6h5fRmp2ZUbP
 F/kwMYy9KaDu3MRa1FSvRAqya0TSP8nhL9OVEfKu+miJ4rbY7w
 r1WpoGK7fOBBxiKOmv7+5rPYPW6Dc0gc6gYDxMaKCY570nWRsN
 OBfRtsIHnj1YefZ108OnnM6BWDuNZRkqYWBITHVStVhxYDDzWH
 5EAY++j8mTKwybbNXbKPTZYZcueiXj309KS0QT+QyIPkdovNVe
 nnb0Co9+Vc64vZ6FxbKZ8UKDQzr2jG515OC33FTJf658XhNI8q
 t5L8LvBp9mBZdjHceaKA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 March 2013, Russell King - ARM Linux wrote:

> Versatile randconfig:
> 
> ERROR: "irq_domain_add_simple" [drivers/gpio/gpio-em.ko] undefined!
> 

I'm pretty sure I submitted a patch for this one before. I'll go looking
for it. IIRC the solution was to export that symbol.

	Arnd
