Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaJGQVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:21:38 -0400
Received: from mail-oi0-f53.google.com ([209.85.218.53]:37291 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbaJGQVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:21:33 -0400
Message-ID: <543412F7.8040909@landley.net>
Date: Tue, 07 Oct 2014 11:21:11 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org
CC: adi-buildroot-devel@lists.sourceforge.net, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org, lguest@lists.ozlabs.org,
        linux-acpi@vger.kernel.org, linux-alpha@vger.kernel.org,
        linux-am33-list@redhat.com, linux-cris-kernel@axis.com,
        linux-efi@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-m32r-ja@ml.linux-m32r.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-xtensa@linux-xtensa.org,
        openipmi-developer@lists.sourceforge.net,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-c6x-dev@linux-c6x.org,
        linux-ia64@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-metag@vger.kernel.org, linux-mips@linux-mips.org,
        linux-parisc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-sh@vger.kernel.org, xen-devel@lists.xenproject.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 05/44] mfd: as3722: Drop reference to pm_power_off from
 devicetree bindings
References: <1412659726-29957-1-git-send-email-linux@roeck-us.net> <1412659726-29957-6-git-send-email-linux@roeck-us.net>
In-Reply-To: <1412659726-29957-6-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/14 00:28, Guenter Roeck wrote:
> Devicetree bindings are supposed to be operating system independent
> and should thus not describe how a specific functionality is implemented
> in Linux.

So your argument is that linux/Documentation/devicetree/bindings should
not be specific to Linux. Merely hosted in the Linux kernel source
repository.

Well that's certainly a point of view.

Rob
