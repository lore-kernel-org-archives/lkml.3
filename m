Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaEETgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 15:36:21 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:40874 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaEETgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 15:36:19 -0400
Date: Mon, 5 May 2014 15:36:16 -0400
From: Tejun Heo <tj@kernel.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>, olebowle@gmx.com,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/4] drivers/base: add managed token devres interfaces
Message-ID: <20140505193616.GR11231@htj.dyndns.org>
References: <cover.1398797954.git.shuah.kh@samsung.com>
 <6cb20ce23f540c883e60e6ce71302042b034c4aa.1398797955.git.shuah.kh@samsung.com>
 <20140501145337.GC31611@htj.dyndns.org>
 <5367E39E.7090401@samsung.com>
 <20140505192633.GQ11231@htj.dyndns.org>
 <CAGoCfiwoFipx79tx6Jkgx5nfU_K9qXdfGe25kzrNb6Jwka0H7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGoCfiwoFipx79tx6Jkgx5nfU_K9qXdfGe25kzrNb6Jwka0H7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 03:30:34PM -0400, Devin Heitmueller wrote:
> On Mon, May 5, 2014 at 3:26 PM, Tejun Heo <tj@kernel.org> wrote:
> > As such, please consider the patches nacked and try to find someone
> > who can shepherd the code.  Mauro, can you help out here?
> 
> We actually discussed this proposal at length at the media summit last
> week.  The patches are being pulled pending further internal review

"being pulled into a tree" or "being pulled for more work"?

> and after Shuah has exercised some other use cases.

I don't have anything against the use case, FWIW.  I just wanna make
sure the code itself ends up with an appropriate initial care taker so
that when something goes wrong it can handled.

Thanks.

-- 
tejun
