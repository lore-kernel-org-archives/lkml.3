Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab3CFTqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 14:46:06 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:55637 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab3CFTqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 14:46:05 -0500
Date: Wed, 6 Mar 2013 20:45:57 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Pavel Machek <pavel@denx.de>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux@arm.linux.org.uk,
        arnd@arndb.de, olof@lixom.net, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        torvalds@linux-foundation.org
Subject: Re: 3.9-rc1 regression in arm dtb build
Message-ID: <20130306204557.3ff80000@skate>
In-Reply-To: <20130306193332.GA6022@amd.pavel.ucw.cz>
References: <20130306193332.GA6022@amd.pavel.ucw.cz>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Pavel Machek,

On Wed, 6 Mar 2013 20:33:32 +0100, Pavel Machek wrote:

> Moves dtb files from arch/arm/boot/ to arch/arm/boot/dtb. That causes
> several problems:
> 
> 1) it is inconsistent with 3.8, making switching between 3.9-rc1 and
> 3.8 tricky

The commit you're pointing to was part of 3.8, and so the dtb move to
arch/arm/boot/dts/ is already here since quite a bit of time. At least,
it's not something you introduced in 3.9-rc1.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
