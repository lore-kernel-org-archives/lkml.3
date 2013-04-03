Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759153Ab3DCOc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:32:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46021 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761Ab3DCOc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:32:58 -0400
Message-ID: <515C3D98.7080203@suse.cz>
Date: Wed, 03 Apr 2013 16:32:56 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Chris Clayton <chris2553@googlemail.com>
Cc: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-3.9.0-rc1+: Output from "make kernelrelease"contains incorrect
 data
References: <513B8FA7.9040200@googlemail.com> <5159534A.1070500@googlemail.com>
In-Reply-To: <5159534A.1070500@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1.4.2013 11:28, Chris Clayton wrote:
> Ping!
> 
> This is still happening with 3.9-rc5.
> 
> [chris:~/kernel/linux]$ make bzImage
> ...
> Kernel: arch/x86/boot/bzImage is ready  (#14)
> [chris:~/kernel/linux]$ make kernelrelease
> scripts/kconfig/conf --silentoldconfig Kconfig
> 3.9.0-rc5
> [chris:~/kernel/linux]$ make kernelrelease
> 3.9.0-rc5

You need to run make -s kernelrelease.

Michal
