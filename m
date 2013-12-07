Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab3LGJdK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 04:33:10 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:53272 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab3LGJdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 04:33:05 -0500
Message-ID: <52A2EBD5.1010707@gmail.com>
Date: Sat, 07 Dec 2013 17:35:17 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: rkuo <rkuo@codeaurora.org>
CC: linux-hexagon@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] arch: hexagon: kernel: hexagon_ksyms.c: export related
 symbols which various modules need
References: <529811AE.8050502@gmail.com> <20131203011222.GA23175@codeaurora.org> <529DCE06.3040508@gmail.com> <20131206182502.GF11490@codeaurora.org>
In-Reply-To: <20131206182502.GF11490@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2013 02:25 AM, rkuo wrote:
> On Tue, Dec 03, 2013 at 08:26:46PM +0800, Chen Gang wrote:
>> Need export all related functions and symbols for various modules with
>> allmodconfig. The related errors:
>>
>>     MODPOST 2879 modules
>>   ERROR: "__vmyield" [sound/sound_firmware.ko] undefined!
>>   ERROR: "__phys_offset" [sound/drivers/snd-dummy.ko] undefined!
>>   ERROR: "ioremap_nocache" [drivers/char/ipmi/ipmi_si.ko] undefined!
>>   ERROR: "__iounmap" [drivers/char/ipmi/ipmi_si.ko] undefined!
>>   ...
>>
>> For including files, need "linux/*" first, then "asm/*". All related
>> included files and symbols need be sorted by alphabetical order.
>>
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>>  arch/hexagon/kernel/hexagon_ksyms.c | 24 ++++++++++++++++++++----
>>  1 file changed, 20 insertions(+), 4 deletions(-)
>>
> 
> OK, hopefully I didn't leave anything out, but I'll try to upstream the
> patches with my tree hopefully in the next window.  Thanks!
> 

Thank you very much !


> Acked-by: Richard Kuo <rkuo@codeaurora.org>
> 

Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water and life which God blessed
