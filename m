Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaE0ANY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 20:13:24 -0400
Received: from mx11.pku.edu.cn ([162.105.129.174]:47233 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751482AbaE0ANT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 20:13:19 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.501
Date: Tue, 27 May 2014 08:13:02 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
Message-ID: <2100345427.23793.1401149582787.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <5383D5F5.2000303@gmail.com>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_[PATCH_0/3]_arch:_uni?=
 =?utf-8?Q?core32:_ksyms:_export_sev?=
 =?utf-8?Q?eral_implemeted_symbols_to_avoid_compiling_failure?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
> unicore32 has implemented 'find_first_bit', 'find_first_zero_bit',
> 'pm_power_off', and '__cpuc_coherent_kern_range', need export them to
> avoid compiling failure.
> 
> The related error (with allmodconfig under unicore32):
> 
>     MODPOST 4039 modules
>   ERROR: "find_first_bit" [sound/soc/codecs/snd-soc-uda1380.ko] undefined!
>   ERROR: "find_first_zero_bit" [net/sctp/sctp.ko] undefined!
>   [...]
>   ERROR: "__cpuc_coherent_kern_range" [drivers/misc/lkdtm.ko] undefined!
>   ERROR: "pm_power_off" [drivers/mfd/retu-mfd.ko] undefined!
>   [...]
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Thanks, I'm waiting for these patches.
And then, I can request-pull in this month.

Xuetao

> ---
>  arch/unicore32/kernel/ksyms.c   | 2 ++
>  arch/unicore32/kernel/process.c | 1 +
>  arch/unicore32/mm/proc-syms.c   | 2 ++
>  3 files changed, 5 insertions(+)
> 
> 
> Thanks.
> -- 
> Chen Gang
> 
> Open, share, and attitude like air, water, and life which God blessed

