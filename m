Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbaJ1Ujl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:39:41 -0400
Received: from mx1.riseup.net ([198.252.153.129]:49703 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbaJ1Ujk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:39:40 -0400
MIME-Version: 1.0
In-Reply-To: <20141028194532.GK25735@saruman>
References: <CA+bYFQZ2T4XPVhnZzfB5yWt6J11SDWf_5KzguEX0VZqmkVxYhQ@mail.gmail.com>
	<20141028194532.GK25735@saruman>
Date: Tue, 28 Oct 2014 18:39:39 -0200
Message-ID: <CA+bYFQbr4RB6XcZYD5b9W_kG6h+kvhGna0e2we67hA+Yr13wdw@mail.gmail.com>
Subject: Re: Errors: Compiling 3.18-rc2
From: Albino Biasutti Neto <bino@riseup.net>
To: balbi@ti.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-28 17:45 GMT-02:00 Felipe Balbi <balbi@ti.com>:
> On Tue, Oct 28, 2014 at 05:41:53PM -0200, Albino Biasutti Neto wrote:
>> Hi
>>
>> I was compile kernel version 3.18-rc2, very errors:
>>
>> # make -j2
>>
>> fs/open.c:822:1: error: expected identifier or ‘(’ before ‘<<’ token
>>  <<<<<<< HEAD
>
> looks like a merge conflict annotation. Are you sure you didn't have
> merge conflicts ? What does 'git show' return ?

$ git show
commit e29bfaac2d572915513c1ec78c61a93373967251
Merge: 536a517 f7e87a4
Author: XXXX <xxx@xxx>
Date:   Tue Oct 28 17:29:46 2014 -0200

    Merge branch 'master' of
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux


                          Albino
                          binoanb.eti.br
