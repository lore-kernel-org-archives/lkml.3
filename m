Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab3LTJdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 04:33:18 -0500
Received: from multi.imgtec.com ([194.200.65.239]:10298 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051Ab3LTJcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 04:32:05 -0500
Message-ID: <52B40E44.9040603@imgtec.com>
Date: Fri, 20 Dec 2013 09:30:44 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>
CC: <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-metag@vger.kernel.org>
Subject: Re: [PATCH] arch: metag: lib: add "umoddi3.S" file for __umoddi3()
References: <52B2E0FA.7090805@gmail.com> <52B2E3DB.7010008@imgtec.com> <52B2F6B7.1050802@gmail.com> <52B2F8DC.8060006@imgtec.com> <52B3A0EA.9010801@gmail.com>
In-Reply-To: <52B3A0EA.9010801@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_12_20_09_32_02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/12/13 01:44, Chen Gang wrote:
> On 12/19/2013 09:47 PM, James Hogan wrote:
>> No, I believe there shouldn't be any use of the C 64bit division/modulo
>> operations in generic kernel code in the first place, so like I said
>> before the code in question should be fixed to use the proper functions
>> in <linux/math64.h>.
>>
> 
> OK, thanks, your idea is one of fix ways.
> 
> Hmm... for me, it is still not a bad idea to add "__umoddi3" to metag.

NAK

Please read this:
http://yarchive.net/comp/linux/64bit_divide.html

Cheers
James

