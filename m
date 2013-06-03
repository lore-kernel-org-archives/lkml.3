Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab3FCJLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:11:16 -0400
Received: from intranet.asianux.com ([58.214.24.6]:1162 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab3FCJLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:11:13 -0400
X-Spam-Score: -100.8
Message-ID: <51AC5D7C.2000905@asianux.com>
Date: Mon, 03 Jun 2013 17:10:20 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andreas Schwab <schwab@linux-m68k.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v2] arch: m68k: math-emu: unsigned issue, 'unsigned long'
 will never be less than zero
References: <51A6F0C6.9050806@asianux.com> <m2a9ndndu5.fsf@linux-m68k.org> <51A70C10.6000408@asianux.com> <CAMuHMdWOxh_YvQyid-PiN7FsM=OC=0YWOzJb86pKaQn3HrjaQw@mail.gmail.com>
In-Reply-To: <CAMuHMdWOxh_YvQyid-PiN7FsM=OC=0YWOzJb86pKaQn3HrjaQw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 05:12 PM, Geert Uytterhoeven wrote:
> On Thu, May 30, 2013 at 10:21 AM, Chen Gang <gang.chen@asianux.com> wrote:
>> 'oldmant.m32[1]' is 'unsigned long' which never '< 0', and the original
>> author wanted to check the highest bit whether set.
>>
>> So need make the bit test explicit (which is better than type cast form
>> 'unsigned long' to 'long').
>>
>> The related warning: (with EXTRA_CFLAGS=-W ARCH=m68k for allmodconfig)
>>   arch/m68k/math-emu/fp_arith.c:522:4: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> 
> Thanks, applied and queued for 3.11!
> 

Thank you too, and pardon: what is '3.11' ?  :-)


Thanks.
-- 
Chen Gang

Asianux Corporation
