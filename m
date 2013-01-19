Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab3AST1v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 14:27:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:50257 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab3AST1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 14:27:50 -0500
Message-ID: <50FAF3FA.4050400@infradead.org>
Date: Sat, 19 Jan 2013 11:28:58 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath9k-devel@venema.h4ckr.net
Subject: Re: mmotm 2013-01-18-15-48 uploaded (ath9k)
References: <20130118234944.5C99C31C240@corp2gmr1-1.hot.corp.google.com>
In-Reply-To: <20130118234944.5C99C31C240@corp2gmr1-1.hot.corp.google.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/13 15:49, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2013-01-18-15-48 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 
> mmotm-readme.txt says
> 
> README for mm-of-the-moment:
> 
> http://www.ozlabs.org/~akpm/mmotm/
> 
> This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> more than once a week.
> 


on i386:

drivers/net/wireless/ath/ath9k/recv.c: In function 'ath_process_fft':
drivers/net/wireless/ath/ath9k/recv.c:1117:2: error: implicit declaration of function 'ath_debug_send_fft_sample' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[6]: *** [drivers/net/wireless/ath/ath9k/recv.o] Error 1



-- 
~Randy
