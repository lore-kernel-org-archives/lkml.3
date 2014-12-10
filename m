Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbaLJHPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 02:15:12 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60850 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757056AbaLJHPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 02:15:09 -0500
Message-ID: <1418195704.5312.31.camel@marge.simpson.net>
Subject: Re: Compiled tridentfb hangs but distribution kernel works fine
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Date: Wed, 10 Dec 2014 08:15:04 +0100
In-Reply-To: <201412092233.17030.linux@rainbow-software.org>
References: <201412092233.17030.linux@rainbow-software.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-09 at 22:33 +0100, Ondrej Zary wrote: 
> Hello,
> I'm doing some work on tridentfb driver but encountered a weird problem.
> 
> When I compile custom kernel with tridentfb, it hangs with Blade3D card (ID 
> 0x9880) in blade_image_blit(). The screen is blank with some artifacts and 
> machine does not respond to ping or keyboard. However, it can be rebooted by 
> Alt+SysRq+B. It works fine with other cards (3DImage 9750 and CyberBlade XP) 
> with no blit implementation. Commenting out contents of blade_image_blit() 
> function makes the hang go away (nothing useful on the screen, of course).
> 
> The weird thing is that the Blade3D card works fine when I load Debian 
> kernels! Debian 3.16-0.bpo.3-686-pae works fine but when I compile 3.16 
> kernel, it hangs.
> 
> Any ideas?

I'd start by looking for what Debian changed in source and/or config.

-Mike

