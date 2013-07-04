Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab3GDIh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 04:37:56 -0400
Received: from pyr75-3-78-192-68-46.fbxo.proxad.net ([78.192.68.46]:53072 "EHLO
	molly.corsac.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab3GDIhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 04:37:51 -0400
Message-ID: <1372927060.26307.0.camel@oban>
Subject: Re: 3.9.7, 3.10-rc7 - UEFI stalls at boot (nothing displayed), when
 booting with mem=300M
From: Yves-Alexis Perez <corsac@debian.org>
To: Luca Barbato <lu_zero@gentoo.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Matthew Thode <prometheanfire@gentoo.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        kernel@gentoo.org, hardened-kernel@gentoo.org
Date: Thu, 04 Jul 2013 10:37:40 +0200
In-Reply-To: <51D50DEE.4080903@gentoo.org>
References: <51CC6CAE.6070401@gentoo.org> <51CC81A2.8040305@gentoo.org>
	 <51D10603.1080403@gentoo.org> <20130701051320.GA6840@srcf.ucam.org>
	 <51D11218.5040601@gentoo.org> <20130701062530.GA7423@srcf.ucam.org>
	 <51D17F15.4080000@gentoo.org> <51D50DEE.4080903@gentoo.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On jeu., 2013-07-04 at 07:53 +0200, Luca Barbato wrote:
> On 07/01/2013 03:07 PM, Luca Barbato wrote:
> > Hopefully I will carve some time next weekend to play the restricted
> > bisect game.
> 
> Release 3.10 apparently doesn't show the problem, I guess problem solved
> for me =)
> 
> lu
> 
I've just tried 3.10.0 with CONFIG_EFI=y and I still can't boot with
mem=300M.

Regards,
-- 
Yves-Alexis

