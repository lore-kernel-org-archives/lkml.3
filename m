Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab3H2E0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 00:26:13 -0400
Received: from intranet.asianux.com ([58.214.24.6]:24685 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab3H2E0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 00:26:12 -0400
X-Spam-Score: -101.0
Message-ID: <521ECD24.5000306@asianux.com>
Date: Thu, 29 Aug 2013 12:25:08 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Suggestion] h8300: built-in: about "can not find built-in.o"
 issue.
References: <521EC935.90200@asianux.com> <521ECAC8.4050308@asianux.com> <521ECCA8.20603@asianux.com>
In-Reply-To: <521ECCA8.20603@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After the recent several issue fix patches (include this suggestion),
The h8300h with defconfig can pass building completely.

And next, I will try to build allmodconfig (finish before 2013-08-31).

Thanks.

On 08/29/2013 12:23 PM, Chen Gang wrote:
> Hello Maintainers:
> 
> When build h8300h with defconfig, an 'built-in' issue occurs. I can add
> an dummy file and let "obj-y := dummy.o" to fix this issue, I am sure
> it is correct, but it seems not 'standard'.
> 
> So welcome any additional suggestions or completions, thanks.
> 
> The related information (with defconfig for h8300h):
> 
> /usr/local/bin/h8300-gchen-elf-ld -mh8300helf -r -o vmlinux.o arch/h8300/platform/h8300h/generic/crt0_ram.o init/built-in.o --start-group usr/built-in.o arch/h8300/kernel/built-in.o arch/h8300/mm/built-in.o arch/h8300/platform/h8300h/built-in.o arch/h8300/platform/h8300h/generic/built-in.o kernel/built-in.o mm/built-in.o fs/built-in.o ipc/built-in.o security/built-in.o crypto/built-in.o block/built-in.o lib/lib.a arch/h8300/lib/lib.a /usr/local/lib/gcc/h8300-gchen-elf/4.7.4/h8300h/int32/libgcc.a lib/built-in.o arch/h8300/lib/built-in.o /usr/local/lib/gcc/h8300-gchen-elf/4.7.4/h8300h/int32/libgcc.a drivers/built-in.o sound/built-in.o firmware/built-in.o net/built-in.o --end-group
> /usr/local/bin/h8300-gchen-elf-ld: cannot find arch/h8300/platform/h8300h/generic/built-in.o: No such file or directory
> make: *** [vmlinux] Error 1
>   
> 
> Thanks.
> --
> Chen Gang.
> 


-- 
Chen Gang
