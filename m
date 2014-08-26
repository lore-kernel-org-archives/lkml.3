Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbaHZTDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 15:03:33 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52000 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbaHZTDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 15:03:32 -0400
Message-ID: <53FCDA03.3050504@infradead.org>
Date: Tue, 26 Aug 2014 12:03:31 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>
Subject: Re: linux-next: Tree for Aug 26 (drbg)
References: <20140826173452.7cc5445c@canb.auug.org.au>
In-Reply-To: <20140826173452.7cc5445c@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/14 00:34, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20140825:
> 
> The net tree gained a build failure for which I reverted a commit.
> 
> The mfd tree still had its build failure so I used the version from
> next-20140822.
> 

on i386:

../include/crypto/drbg.h:157:2: warning: left shift count >= width of type [enabled by default]
../include/crypto/drbg.h:163:2: warning: left shift count >= width of type [enabled by default]

I guess that someone has already seen this but I haven't noticed any reports
of it.


-- 
~Randy
