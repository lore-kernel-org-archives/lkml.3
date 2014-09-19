Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbaISHKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 03:10:25 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:46381 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757378AbaISHKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 03:10:23 -0400
Date: Fri, 19 Sep 2014 02:10:18 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-kbuild@vger.kernel.org, llvmlinux@lists.linuxfoundation.org,
        Vinicius Tinti <viniciustinti@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        linux-kernel@vger.kernel.org
Subject: Re: How to build the kernel with Clang?
Message-ID: <20140919021018.16c117c5@as>
In-Reply-To: <20140919131021.EE3E.AA925319@jp.panasonic.com>
References: <20140919131021.EE3E.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2014 13:10:21 +0900
Masahiro Yamada <yamada.m@jp.panasonic.com> wrote:

> Hi Clang folks,
> 
> 
> I'd like to know the status of Clang support
> in the Linux mainline.
> 
> 
> I can see some "clang" specific parts in makefiles,
> so I guess Clang is already supported to a certain extent.
> 
> 
> I just tried to build with "HOSTCC=clang CC=clang"
> but it would not work.
> 
> Is there any tips I am missing here?
> 

Let Me Google That For You:

http://llvm.linuxfoundation.org/index.php/Main_Page
