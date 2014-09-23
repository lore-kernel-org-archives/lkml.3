Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbaIWMjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 08:39:00 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:58988 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaIWMi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 08:38:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/9] Documentation: bindings: net: add the Marvell PXA168 Ethernet controller
Date: Tue, 23 Sep 2014 14:38:39 +0200
Message-ID: <51745791.Wuu5QiQB2e@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411474536-22626-4-git-send-email-antoine.tenart@free-electrons.com>
References: <1411474536-22626-1-git-send-email-antoine.tenart@free-electrons.com> <1411474536-22626-4-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:8Ca22btnOJ31tLNZtFKOeK6Fzu9G1bpSPr0INze2sWp
 b3rC0RA+5Ay9/pak4jMMn9uff7ujc6bgO41WnkZc+ReSNHNBR9
 OjwGDUbkZL+xh5mPANhttZs5dOvYA/tfL/fVYI0SS2HIiMQlFy
 9awXOVCmkFs11142g3yVW/N+z+YVHV9r9Nj2ed+xi/XC43PymQ
 qbhU5kdreMH3qNl2vdWngcgbqw2bA0vymIBqhYCwem3yMDAyDs
 Clu1CsMSXXweGimUHJDkYvAL+C9oZSMV1JjGRylYLSBeoQv/bL
 9XCWcSjDjbcMvd1yiFc0L7w0BV2DotpTne3/cz3c08xVVTyBrD
 OODXOMy92ZGLXpVeZN1M=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 14:15:30 Antoine Tenart wrote:
> +Optional properties:
> +- port-id: should be '0','1' or '2'.
> +- phy-addr: MDIO address of the PHY.
> +- local-mac-address: see ethernet.txt file in the same directory.
> +
> 

I believe new bindings should not use "phy-addr" properties, but
instead use a phy-handle property pointing to a phy device instead.

The port-id property description could be a little more verbose.
What do those numbers actually mean?

	Arnd
