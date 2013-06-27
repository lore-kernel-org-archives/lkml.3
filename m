Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab3F0SQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 14:16:57 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:59878 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712Ab3F0SQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 14:16:55 -0400
Message-ID: <51CC81A2.8040305@gentoo.org>
Date: Thu, 27 Jun 2013 20:17:06 +0200
From: Luca Barbato <lu_zero@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130411 Thunderbird/17.0.5
MIME-Version: 1.0
To: prometheanfire@gentoo.org
CC: linux-kernel@vger.kernel.org, linux-devel@vger.kernel.org,
        mjg59@srcf.ucam.org, torvalds@linux-foundation.org, kernel@gentoo.org,
        hardened-kernel@gentoo.org, corsac@debian.org
Subject: Re: 3.9.7, 3.10-rc7 - UEFI stalls at boot (nothing displayed), when
 booting with mem=300M
References: <51CC6CAE.6070401@gentoo.org>
In-Reply-To: <51CC6CAE.6070401@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 06:47 PM, Matthew Thode wrote:
> There is an early boot failure with linux-3.[9,10].??? when booting
> using uefi on low memory systems.
> 
> This seems like it might be hardware specific, I am running on a Lenovo
> T520, running bios version 1.42, firmware rev 1.36.
> 

Had the same problem with linux 3.10-rc1 and a stock mac book pro, I
hadn't investigated much further though.

lu

