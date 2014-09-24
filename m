Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbaIXSzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:55:50 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:40515 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbaIXSzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:55:48 -0400
Message-ID: <542313B1.1020803@converseincode.com>
Date: Wed, 24 Sep 2014 11:55:45 -0700
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Masahiro Yamada <yamada.m@jp.panasonic.com>, linux-kbuild@vger.kernel.org,
        llvmlinux@lists.linuxfoundation.org
CC: Vinicius Tinti <viniciustinti@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: How to build the kernel with Clang?
References: <20140919131021.EE3E.AA925319@jp.panasonic.com>
In-Reply-To: <20140919131021.EE3E.AA925319@jp.panasonic.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/14 21:10, Masahiro Yamada wrote:
> Hi Clang folks,
>
>
> I'd like to know the status of Clang support
> in the Linux mainline.
Still a work in progress.  You still need to use the LLVMLinux patches 
on top of mainline to get it to work. We're upstreaming those patches as 
fast as we can.

> I can see some "clang" specific parts in makefiles,
> so I guess Clang is already supported to a certain extent.
Some of the required parts are there. But mainline currently won't 
compile out of the box with clang.

> I just tried to build with "HOSTCC=clang CC=clang"
> but it would not work.
>
> Is there any tips I am missing here?
Try building from our kernel repo listed on http://llvm.linuxfoundation.org

Thanks,

Behan

-- 
Behan Webster
behanw@converseincode.com

