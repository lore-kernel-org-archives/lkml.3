Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaBTFlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 00:41:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50451 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaBTFlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 00:41:39 -0500
Message-ID: <53059590.7040506@infradead.org>
Date: Wed, 19 Feb 2014 21:41:36 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: mmotm 2014-02-19-16-07 uploaded (sound/soc/intel/sst-dsp.c)
References: <20140220000827.17F275A42DC@corp2gmr1-2.hot.corp.google.com>
In-Reply-To: <20140220000827.17F275A42DC@corp2gmr1-2.hot.corp.google.com>
Content-Type: text/plain; charset=windows-1256
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/14 16:08, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2014-02-19-16-07 has been uploaded to
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
(from linux-next)

  CC      sound/soc/intel/sst-dsp.o
sound/soc/intel/sst-dsp.c: In function 'sst_dsp_outbox_write':
sound/soc/intel/sst-dsp.c:218:2: error: implicit declaration of function 'memcpy_toio' [-Werror=implicit-function-declaration]
sound/soc/intel/sst-dsp.c: In function 'sst_dsp_outbox_read':
sound/soc/intel/sst-dsp.c:231:2: error: implicit declaration of function 'memcpy_fromio' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[4]: *** [sound/soc/intel/sst-dsp.o] Error 1


-- 
~Randy
