Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933688AbaEGNVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:21:17 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45019 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933140AbaEGNVP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:21:15 -0400
Date: Wed, 7 May 2014 14:20:47 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "'Andi Kleen'" <andi@firstfloor.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>
Subject: Re: A reduced Linux network stack for small systems
Message-ID: <20140507142047.46012957@alan.etchedpixels.co.uk>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F70CFB5@AcuExch.aculab.com>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
	<063D6719AE5E284EB5DD2968C1650D6D0F70CFB5@AcuExch.aculab.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You may want some size reduction to run in 16MB, but it is not as problematic
> as running in 2MB.
> 
> With that little memory I wouldn't want to run anything that relied on
> dynamic memory allocation (after startup) - except for fixed size data
> buffers.

You mean like µhttpd 8) Been there, done that and Tom in fact sent me the
patches to port it to Linux from 2.11BSD PDP/11.

You can do a lot in a very small space. Heck you can run a full 2.11BSD
on a PDP/11 in 1MB, including network stack. You used to be able to build
a full self hosting Linux 1.x on a 4MB 386.

If you are using glibc and GNU tools it isn't going to work, but long ago
tools were written which just did the job they were supposed to do at the
time and were small and tidy. Programmers were expected to use shell
scripts to combine them for harder jobs rather than be the one person a
year who invoked gnu-wibble --format-sideways-while-singing
--tune=waltzing-matilda

Alan
