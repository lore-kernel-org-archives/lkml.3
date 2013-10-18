Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab3JRNTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:19:54 -0400
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:55687 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab3JRNTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:19:53 -0400
Date: Fri, 18 Oct 2013 16:19:49 +0300 (EEST)
From: Joonas Saarinen <jza@saunalahti.fi>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org
Message-ID: <31997499.9414731382102390275.JavaMail.jza@saunalahti.fi>
Subject: Re: AMD Bobcat cpufreq
MIME-Version: 1.0
Content-Type: text/plain; Charset=iso-8859-1; Format=Flowed
Content-Transfer-Encoding: 7bit
X-Mailer: Saunalahti webmail - http://saunalahti.fi
X-Originating-IP: 80.223.182.224
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov [bp@alien8.de] wrote:
> Once you've done that successfully, you need to run as root:
> 
> $ cd tools/power/cpupower/
> $ LD_LIBRARY_PATH=. ./cpupower frequency-info

This is what I get:

analyzing CPU 0:
  driver: acpi-cpufreq
  CPUs which run at the same hardware frequency: 0
  CPUs which need to have their frequency coordinated by software: 0
  hardware limits: 800 MHz - 1000 MHz
  available frequency steps: 1000 MHz, 800 MHz
  available cpufreq governors: conservative, ondemand, userspace, powersave, performance
  current policy: frequency should be within 800 MHz and 1000 MHz.
                  The governor "ondemand" may decide which speed to use
                  within this range.
  current CPU frequency is 1000 MHz (asserted by call to hardware).
  cpufreq stats: 1000 MHz:-nan%, 800 MHz:-nan%  (646)
  boost state support:
    Supported: yes
    Active: yes

It's promising that the boost state support is "supported and active" 
but the output is still kind of sparse. There's no mention about
specific turbo states, nor do I get /proc/cpuinfo or that cpupower tool
ever to show an evidence that the CPU is going to 1333MHz. On Windows
CPU-Z showed it constantly visiting that state.

That's all for now.

Joonas

