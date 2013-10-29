Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab3J2GJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 02:09:03 -0400
Received: from intranet.asianux.com ([58.214.24.6]:37081 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3J2GJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 02:09:00 -0400
X-Spam-Score: -100.8
Message-ID: <526F50BE.6020505@asianux.com>
Date: Tue, 29 Oct 2013 14:07:58 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vineet Gupta <vineetg76@gmail.com>
CC: James Hogan <james.hogan@imgtec.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [PATCH v2] arch: use ASM_NL instead of ';' for assembler new
 line character in the macro
References: <526E3CE2.2070405@asianux.com> <526E6A92.6090301@synopsys.com> <526F09B8.9030202@asianux.com> <526F11C0.1030809@asianux.com> <526F149A.3000306@asianux.com> <526F4DCF.5010406@synopsys.com>
In-Reply-To: <526F4DCF.5010406@synopsys.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 01:55 PM, Vineet Gupta wrote:
> On 10/29/2013 07:21 AM, Chen Gang wrote:
>> For some assemblers, they use another character as newline in a macro
>> (e.g. arc uses '`'), so for generic assembly code, need use ASM_NL (a
>> macro) instead of ';' for it.
>>
>> Also need notice about code styles ('\t' for each line).
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  arch/arc/include/asm/linkage.h |    2 ++
>>  include/linux/linkage.h        |   19 ++++++++++++-------
> 
> Acked-by: Vineet Gupta <vgupta@synopsys.com>
> 


Thank you very much!


-- 
Chen Gang
