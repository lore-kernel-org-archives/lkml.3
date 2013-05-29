Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965872Ab3E2L73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:59:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64595 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965722Ab3E2L72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:59:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roger Quadros <rogerq@ti.com>
Cc: gregkh@linuxfoundation.org, balbi@ti.com, stern@rowland.harvard.edu,
        kishon@ti.com, adrienverge@gmail.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] USB: PHY: Improve PHY selection logic
Date: Wed, 29 May 2013 13:59:24 +0200
Message-ID: <4843252.ptIdMxoBef@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1369827811-534-1-git-send-email-rogerq@ti.com>
References: <1369827811-534-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:DNyvBQYYW9adk2PdFfpIsGqID7T/IL2zzPWIPUbUaSr
 llc1u8fCVorEfXN4dXHe/CxLJNLb8D0QxjhPBnDafU3XMFTs2X
 1pelJ6ej9eoANGMrikGxGGa7Ix8d6dLAhI/ixIo158D/+5dpnc
 9x0WADWzSUQSIcbkSI2aK206OFajLxuq45XRYTMS9HnVhBtbS5
 atyUMV27IXsgEWAeFr0syYRbvsabaqfWEJ1dFc8DiU0HO2hIAk
 YNCI5T+dj95yexFjX9gjVQMDTL0WuaDN1RPTDLLJ5riU0Bfksm
 FLt5wWsfVawfwrLOGFyTcQMKvqtjk7BRs530vAo2rf+vse04E7
 1GgF68OmtH7VfA+VrI48=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 May 2013 14:43:26 Roger Quadros wrote:
> 
> Improve Kconfig so that the relevant PHY driver can be explicitely
> selected by the controller driver instead of relying on the user
> to do so.
> 
> Detailed description in patch 1.

I think you have to fold patches 3-5 into patch 1, otherwise you
get a circular dependency between the Kconfig options during
bisection.

	Arnd
