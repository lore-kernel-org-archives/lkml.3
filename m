Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab3LPThf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 14:37:35 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:36818 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab3LPThc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 14:37:32 -0500
Message-ID: <52AF5679.1090701@linaro.org>
Date: Mon, 16 Dec 2013 11:37:29 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: randconfig build error with next-20131216, in drivers/staging/android/ion
References: <CA+r1Zhh-ayJRcuApAh_E3ofM3Q=xH3Wo-ZHSdr7rCYd+YAKGaw@mail.gmail.com>
In-Reply-To: <CA+r1Zhh-ayJRcuApAh_E3ofM3Q=xH3Wo-ZHSdr7rCYd+YAKGaw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2013 05:53 AM, Jim Davis wrote:
> Building with the attached random configuration file,
>
> drivers/built-in.o: In function `ion_heap_freelist_add':
> (.text+0xf292c): undefined reference to `rt_mutex_lock'
> drivers/built-in.o: In function `ion_heap_freelist_add':
> (.text+0xf2958): undefined reference to `rt_mutex_unlock'
> drivers/built-in.o: In function `ion_heap_freelist_size':
> (.text+0xf2990): undefined reference to `rt_mutex_lock'
> drivers/built-in.o: In function `ion_heap_freelist_size':
> (.text+0xf29a0): undefined reference to `rt_mutex_unlock'
> drivers/built-in.o: In function `ion_heap_deferred_free':
> ion_heap.c:(.text+0xf2a2d): undefined reference to `rt_mutex_lock'
> ion_heap.c:(.text+0xf2a48): undefined reference to `rt_mutex_unlock'
> ion_heap.c:(.text+0xf2a6e): undefined reference to `rt_mutex_unlock'
> drivers/built-in.o: In function `ion_heap_freelist_drain':
> (.text+0xf2ab2): undefined reference to `rt_mutex_lock'
> drivers/built-in.o: In function `ion_heap_freelist_drain':
> (.text+0xf2aed): undefined reference to `rt_mutex_unlock'
> drivers/built-in.o: In function `ion_heap_init_deferred_free':
> (.text+0xf2b7c): undefined reference to `__rt_mutex_init'
> make: *** [vmlinux] Error 1

Thanks for the heads up! I'll chase these down!
-john

