Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbaIMFCN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 01:02:13 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:57380 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaIMFCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 01:02:12 -0400
Message-ID: <5413CFD1.4020300@gmail.com>
Date: Sat, 13 Sep 2014 07:02:09 +0200
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: VGA resume & thaw (wake up from S3 & S4) broken - kernel exclusively
References: <5413CEA5.3060403@gmail.com>
In-Reply-To: <5413CEA5.3060403@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.09.2014 06:57, poma wrote:
> 
> Actually I have nothing to show cause logs are all OK.
> Haha, it seems to me that the bugs become intelligent.
> 
> 3.15.10-201.fc20.x86_64
> 3.16.2-200.fc20.x86_64
> 3.17.0-0.rc4.git3.2.fc22.1.x86_64
>  nouveau  [     DRM] suspending display...
>  nouveau  [     DRM] unpinning framebuffer(s)...
>  nouveau  [     DRM] evicting buffers...
>  nouveau  [     DRM] waiting for kernel channels to go idle...
>  nouveau  [     DRM] suspending client object trees...
>  nouveau  [     DRM] suspending kernel object tree...
> ...
>  nouveau  [     DRM] re-enabling device...
>  nouveau  [     DRM] resuming kernel object tree...
>  nouveau  [   VBIOS][0000:02:00.0] running init tables
>  nouveau  [  PTHERM][0000:02:00.0] fan management: automatic
>  nouveau  [     CLK][0000:02:00.0] --: core 566 MHz shader 1400 MHz memory 399 MHz
>  nouveau  [     DRM] resuming client object trees...
>  nouveau  [     DRM] resuming display...
>  nouveau 0000:02:00.0: no hotplug settings from platform
>  nouveau 0000:02:00.0: no hotplug settings from platform
> 
> Logs(dmesg) are literally identical.
> 
> 3.15.10-201.fc20.x86_64 - nouveau(fb) resume & thaw PASSED, and that's all what works.
>         Kernels >= 3.16 - nouveau(fb) resume & thaw BROKEN
>             ALL Kernels - vesa(fb)    resume & thaw BROKEN.
> 
> 

Excusez-moi, 
BROKEN == The display remains OFF.


poma


