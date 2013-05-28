Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab3E1E6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 00:58:08 -0400
Received: from intranet.asianux.com ([58.214.24.6]:46941 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab3E1E6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 00:58:07 -0400
X-Spam-Score: -100.8
Message-ID: <51A4392B.5090402@asianux.com>
Date: Tue, 28 May 2013 12:57:15 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Max Filippov <jcmvbkbc@gmail.com>
CC: chris@zankel.net, linux-xtensa@linux-xtensa.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: xtensa: include: asm: compiling issue, need cmpxchg64()
 defined.
References: <51A34A0D.5070407@asianux.com> <CAMo8BfKmZjH5ysA=d9xpDAR8kb_WoXFinBQ9nMMGRLmnpjQYcA@mail.gmail.com>
In-Reply-To: <CAMo8BfKmZjH5ysA=d9xpDAR8kb_WoXFinBQ9nMMGRLmnpjQYcA@mail.gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 12:19 AM, Max Filippov wrote:
> On Mon, May 27, 2013 at 3:57 PM, Chen Gang <gang.chen@asianux.com> wrote:
>>
>> When compiling with 'allmodconfig', some of drivers need cmpxchg64(),
>> xtensa does not supply 64-bit implementation for 'xchg', so use the
>> 'generic' implementation.
>>
>> e.g. (for next-20130527 tree):
>>   drivers/block/blockconsole.c:164:2: error: implicit declaration of function ¡®cmpxchg64¡¯ [-Werror=implicit-function-declaration]
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  arch/xtensa/include/asm/cmpxchg.h |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> Taken to the xtensa-fixes tree. Thanks.
> 

Thank you too.

-- 
Chen Gang

Asianux Corporation
