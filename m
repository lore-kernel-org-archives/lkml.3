Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab3IMMZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 08:25:42 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:43107 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab3IMMZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 08:25:38 -0400
Message-ID: <5233043E.3000506@gmail.com>
Date: Fri, 13 Sep 2013 14:25:34 +0200
From: Gabriel de Perthuis <g2p.code@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
CC: ubuntu-devel@lists.ubuntu.com, linux-kernel@vger.kernel.org,
        bcache <linux-bcache@vger.kernel.org>
Subject: Re: [ANN] Ubuntu PPA for bcache-tools and blocks
References: <5232F139.4080508@gmail.com> <CACaajQtmLuA6M2Sj-=GJ6BGLicYi3Wn=qWmK84UA_PEa84MSYg@mail.gmail.com>
In-Reply-To: <CACaajQtmLuA6M2Sj-=GJ6BGLicYi3Wn=qWmK84UA_PEa84MSYg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is that possible to create bcached kernel for raring? I like
> autoapdating and packages created via standard way. So I can install
> source package and headers and can vbuild to it dkms modules.

A backported dkms module isn't feasible, bcache comes with work
on the block layer.  Raring users should the kernels I've linked:

> Backported Ubuntu kernels are available at
> 
> http://kernel.ubuntu.com/~kernel-ppa/mainline/

Latest is this one
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.11-saucy/
And there's a bit of docs here:
https://wiki.ubuntu.com/Kernel/MainlineBuilds

Other options for raring users: upgrade to saucy
http://askubuntu.com/questions/12909/
Or build your own kernel
https://wiki.ubuntu.com/KernelTeam/GitKernelBuild
