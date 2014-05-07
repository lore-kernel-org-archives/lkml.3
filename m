Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbaEGW4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 18:56:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53049 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaEGW4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 18:56:15 -0400
Message-ID: <536ABA0C.7000907@infradead.org>
Date: Wed, 07 May 2014 15:56:12 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Luciano Coelho <luciano.coelho@nokia.com>,
        Luciano Coelho <coelho@ti.com>,
        Juuso Oikarinen <juuso.oikarinen@nokia.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Build regressions/improvements in v3.15-rc4 (wireless/ti/wlcore)
References: <1399377878-29995-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1399377878-29995-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 05:04 AM, Geert Uytterhoeven wrote:
> Below is the list of build error/warning regressions/improvements in
> v3.15-rc4[1] compared to v3.14[2].
> 
> 
> 
> *** WARNINGS ***
> 
> 181 regressions:

>   + /scratch/kisskb/src/drivers/net/wireless/ti/wlcore/spi.c: warning: the frame size of 38080 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 317:1

Does that function:  wl12xx_spi_raw_write() in spi.c actually work without crashing??

-- 
~Randy
