Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215Ab3AQBZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:25:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:40138 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab3AQBZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:25:24 -0500
Message-ID: <50F75349.2050609@infradead.org>
Date: Wed, 16 Jan 2013 17:26:33 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: werner <w.landgraf@ru.ru>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: Linux 3.8-rc1: compiling problem in perf-event-p6.o
References: <web-834819484@zbackend1.aha.ru>
In-Reply-To: <web-834819484@zbackend1.aha.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/13 06:50, werner wrote:
> We are now on -rc3 and someone should correct this, finally
> 
> This is a regression, it was not before, on 3.6
> 
> This messes up any compilation of the whole kernel, it results in don't be produced vmlinuz
> 
> arch/x86/kernel/cpu/perf_event_p6.o   depends on so much things that I don't get it switched off, I suppose it's necesary for the most systems
> 
> 
> W.Landgraf
> 
> 
> 
> 
> 
> 
> =================
> The problem continues with 3.8-rc
> 
> This is grave, no vmlinuz is produced.
> 
> 
> wl
> 
>   CC arch/x86/kernel/cpu/perf_event.o
>   CC arch/x86/kernel/cpu/perf_event_amd.o
>   CC arch/x86/kernel/cpu/perf_event_p6.o
> arch/x86/kernel/cpu/perf_event_p6.c:22: error: p6_hw_cache_event_ids causes a section type conflict
> make[3]: [arch/x86/kernel/cpu/perf_event_p6.o] Error 1 (ignored)
>   CC arch/x86/kernel/cpu/perf_event_knc.o
>   CC arch/x86/kernel/cpu/perf_event_p4.o
>   CC arch/x86/kernel/cpu/perf_event_intel_lbr.o
> 
> ================================================
> There ocurs a compiling error in perf-event-p6.o , any regression, unfortunately I lost the compiling list but I think it was any incompatibility / redefinition with something else, pls check and correct that, if not already done
> W.Landgraf

Hi,

I don't see this problem on 3.8-rc1 or -rc3.
Maybe a difference/problem in gcc??


-- 
~Randy
