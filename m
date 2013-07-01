Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab3GANHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 09:07:19 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48224 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553Ab3GANHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 09:07:17 -0400
Message-ID: <51D17F15.4080000@gentoo.org>
Date: Mon, 01 Jul 2013 15:07:33 +0200
From: Luca Barbato <lu_zero@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130411 Thunderbird/17.0.5
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Matthew Thode <prometheanfire@gentoo.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, kernel@gentoo.org,
        hardened-kernel@gentoo.org, corsac@debian.org
Subject: Re: 3.9.7, 3.10-rc7 - UEFI stalls at boot (nothing displayed), when
 booting with mem=300M
References: <51CC6CAE.6070401@gentoo.org> <51CC81A2.8040305@gentoo.org> <51D10603.1080403@gentoo.org> <20130701051320.GA6840@srcf.ucam.org> <51D11218.5040601@gentoo.org> <20130701062530.GA7423@srcf.ucam.org>
In-Reply-To: <20130701062530.GA7423@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2013 08:25 AM, Matthew Garrett wrote:
> On Mon, Jul 01, 2013 at 07:22:32AM +0200, Luca Barbato wrote:
> 
>> MacBookPro8,2 with efi-stub, loading directly from the efi shell w/out
>> any memory restriction.
> 
> How do you know this is the same issue?
> 

I believe in duck bugs, if the range of broken commits looks the same,
and the behaviour looks the same, probably the cause is the same, or at
least I once can be investigated on real hardware and probably once
fixed the other might be fixed as well.

I have not deep knowledge of uefi/efi internals so I'll need some
pointers to figure out exactly why it happens.

Hopefully I will carve some time next weekend to play the restricted
bisect game.

lu
