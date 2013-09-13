Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab3IMMxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 08:53:45 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:46942 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab3IMMxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 08:53:37 -0400
Date: Fri, 13 Sep 2013 14:53:33 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Current git kernel reboots early durning boot
Message-ID: <20130913125333.GA355@x4>
References: <20130909111840.GB359@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909111840.GB359@x4>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.09.09 at 13:18 +0200, Markus Trippelsdorf wrote:
> I've hit an odd issue on the current git tree. When I build a kernel
> with my attached config and a very simple local patch (also attached), I
> get a resulting kernel that just reboots my machine very early during
> boot. When I try to boot the kernel under qemu, qemu just spins forever
> without printing anything to the console. This happens when I build with
> gcc-4.8.1 and gold (linker). When I drop the local kernel patch or
> switch to the bfd linker, the kernel boots normally...
> 
> Any ideas what might be going on?

It turned out that I accidentally used a gold linker, that got
miscompiled by gcc-4.9.0...

-- 
Markus
