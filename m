Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788Ab3GRADK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 20:03:10 -0400
Received: from intranet.asianux.com ([58.214.24.6]:21455 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516Ab3GRADI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 20:03:08 -0400
X-Spam-Score: -100.8
Message-ID: <51E7307C.50505@asianux.com>
Date: Thu, 18 Jul 2013 08:02:04 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: Ralf Baechle <ralf@linux-mips.org>,
        =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH v2] arch: tile: include: asm: add cmpxchg64() definition
References: <51CA6D21.3090901@asianux.com> <51CC492C.1040105@tilera.com> <51CCD891.8000806@asianux.com> <51CCEC27.8050508@asianux.com> <20130628150941.GA22767@linux-mips.org> <51D0E4B3.6080402@asianux.com> <51D0E7BF.9030206@asianux.com> <51E6CA5B.6030501@tilera.com>
In-Reply-To: <51E6CA5B.6030501@tilera.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 12:46 AM, Chris Metcalf wrote:
> On 6/30/2013 10:21 PM, Chen Gang wrote:
>> Need add cmpxchg64(), or will cause compiling issue.
>>
>> Need define it as cmpxchg() only for 64-bit operation, since cmpxchg()
>> can support 8 bytes.
>>
>> The related error (with allmodconfig):
>>
>>   drivers/block/blockconsole.c: In function ‘bcon_advance_console_bytes’:
>>   drivers/block/blockconsole.c:164:2: error: implicit declaration of function ‘cmpxchg64’ [-Werror=implicit-function-declaration]
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> 
> Thanks, taken into the tile tree.
> 

Thank you too.

:-)

-- 
Chen Gang
