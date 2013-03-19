Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab3CSHBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 03:01:19 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:46674 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab3CSHBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 03:01:18 -0400
Message-ID: <51480D07.5060505@lab.ntt.co.jp>
Date: Tue, 19 Mar 2013 16:00:23 +0900
From: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/mod: add device table offsets file to list of
 files to clean
References: <1362391043.6156.2.camel@nexus.lab.ntt.co.jp>
In-Reply-To: <1362391043.6156.2.camel@nexus.lab.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On 2013/03/04 18:57, Fernando Luis Vázquez Cao wrote:
> From: Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp>
>
> This file is generated so it does not get cleaned automagically. In other words
> we need to added to the clean-files list.
>
> Signed-off-by: Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp>
> ---
>
> diff -urNp linux-3.9-rc1-orig/scripts/mod/Makefile linux-3.9-rc1/scripts/mod/Makefile
> --- linux-3.9-rc1-orig/scripts/mod/Makefile	2013-03-04 16:09:29.297904000 +0900
> +++ linux-3.9-rc1/scripts/mod/Makefile	2013-03-04 18:06:16.359389000 +0900
> @@ -49,3 +49,5 @@ $(obj)/elfconfig.h: $(obj)/empty.o $(obj
>   	$(call if_changed,elfconfig)
>   
>   targets += elfconfig.h
> +
> +clean-files	:= $(devicetable-offsets-file)

Do you see any problem with this patch?

Thanks,
Fernando
