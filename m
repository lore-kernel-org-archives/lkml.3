Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab3GDFx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 01:53:29 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52803 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934Ab3GDFx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 01:53:28 -0400
Message-ID: <51D50DEE.4080903@gentoo.org>
Date: Thu, 04 Jul 2013 07:53:50 +0200
From: Luca Barbato <lu_zero@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130411 Thunderbird/17.0.5
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Matthew Thode <prometheanfire@gentoo.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, kernel@gentoo.org,
        hardened-kernel@gentoo.org, corsac@debian.org
Subject: Re: 3.9.7, 3.10-rc7 - UEFI stalls at boot (nothing displayed), when
 booting with mem=300M
References: <51CC6CAE.6070401@gentoo.org> <51CC81A2.8040305@gentoo.org> <51D10603.1080403@gentoo.org> <20130701051320.GA6840@srcf.ucam.org> <51D11218.5040601@gentoo.org> <20130701062530.GA7423@srcf.ucam.org> <51D17F15.4080000@gentoo.org>
In-Reply-To: <51D17F15.4080000@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2013 03:07 PM, Luca Barbato wrote:
> Hopefully I will carve some time next weekend to play the restricted
> bisect game.

Release 3.10 apparently doesn't show the problem, I guess problem solved
for me =)

lu

