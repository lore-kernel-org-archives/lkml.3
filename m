Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144Ab3J2BJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 21:09:35 -0400
Received: from intranet.asianux.com ([58.214.24.6]:30996 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767Ab3J2BJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 21:09:34 -0400
X-Spam-Score: -100.8
Message-ID: <526F0A90.6030007@asianux.com>
Date: Tue, 29 Oct 2013 09:08:32 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vineet Gupta <vineetg76@gmail.com>
CC: "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "Mischa.Jonker@synopsys.com" <Mischa.Jonker@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arc: kernel: kgdb: add default implementation for kgdb_roundup_cpus()
References: <526898F1.7010609@asianux.com> <526E6CC0.9090801@synopsys.com>
In-Reply-To: <526E6CC0.9090801@synopsys.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2013 09:55 PM, Vineet Gupta wrote:
> On 10/24/2013 09:21 AM, Chen Gang wrote:
>> arc supports kgdb, but need update -- add function kgdb_roundup_cpus(),
>> or can not pass compiling. At present, add the simple generic one just
>> like other architectures(e.g. tile, mips ...).
>>
>> The related error (with allmodconfig):
>>
>>   kernel/built-in.o: In function `kgdb_cpu_enter':
>>   kernel/debug/debug_core.c:580: undefined reference to `kgdb_roundup_cpus'
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> 
> Applied for 3.13.
> 


Thanks.
-- 
Chen Gang
