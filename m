Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab3GAElT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 00:41:19 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:40643 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab3GAElS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 00:41:18 -0400
Message-ID: <51D1087E.3010304@gentoo.org>
Date: Mon, 01 Jul 2013 06:41:34 +0200
From: Luca Barbato <lu_zero@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130411 Thunderbird/17.0.5
MIME-Version: 1.0
To: prometheanfire@gentoo.org
CC: linux-kernel@vger.kernel.org, linux-devel@vger.kernel.org,
        mjg59@srcf.ucam.org, torvalds@linux-foundation.org, kernel@gentoo.org,
        hardened-kernel@gentoo.org, corsac@debian.org
Subject: Re: 3.9.7, 3.10-rc7 - UEFI stalls at boot (nothing displayed), when
 booting with mem=300M
References: <51CC6CAE.6070401@gentoo.org> <51CC81A2.8040305@gentoo.org> <51D10603.1080403@gentoo.org>
In-Reply-To: <51D10603.1080403@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2013 06:30 AM, Matthew Thode wrote:

> You had the problem where it was blank on boot (right after grub, no
> kernel messages at all)?  Sounds like this might not be limited to just
> Lenovo then.

no grub, efi-stub directly from the efi shell.

> mjg59, is there anything I can do to help move this bug forward?  I've
> done all I can think of (even tried a serial expresscard slot for logging).

If you feel like bisecting seems the only option =_=

lu

