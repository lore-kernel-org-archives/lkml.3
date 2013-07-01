Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab3GAFWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 01:22:16 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:42486 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab3GAFWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 01:22:14 -0400
Message-ID: <51D11218.5040601@gentoo.org>
Date: Mon, 01 Jul 2013 07:22:32 +0200
From: Luca Barbato <lu_zero@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130411 Thunderbird/17.0.5
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Matthew Thode <prometheanfire@gentoo.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, kernel@gentoo.org,
        hardened-kernel@gentoo.org, corsac@debian.org
Subject: Re: 3.9.7, 3.10-rc7 - UEFI stalls at boot (nothing displayed), when
 booting with mem=300M
References: <51CC6CAE.6070401@gentoo.org> <51CC81A2.8040305@gentoo.org> <51D10603.1080403@gentoo.org> <20130701051320.GA6840@srcf.ucam.org>
In-Reply-To: <20130701051320.GA6840@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2013 07:13 AM, Matthew Garrett wrote:
> On Sun, Jun 30, 2013 at 11:30:59PM -0500, Matthew Thode wrote:
> 
>> mjg59, is there anything I can do to help move this bug forward?  I've
>> done all I can think of (even tried a serial expresscard slot for logging).
> 
> It does sound like a bug, but unfortunately unless it can be duplicated 
> on real hardware without restrictive mem= arguments it's likely to be 
> low on my priorities - there's still enough UEFI bugs that hit people in 
> default configurations that they tend to get priority, I'm afraid.
> 

real hardware ->

MacBookPro8,2 with efi-stub, loading directly from the efi shell w/out
any memory restriction.

I guess I should try to get more information for you and see if it isn't
some configuration quirk.

lu
