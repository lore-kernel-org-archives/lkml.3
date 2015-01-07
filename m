Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbbAGVIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 16:08:19 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:41153 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbbAGVIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 16:08:17 -0500
Message-ID: <54ADA03B.4060708@de.ibm.com>
Date: Wed, 07 Jan 2015 22:08:11 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: paulmck@linux.vnet.ibm.com, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] next: sh: Fix compile error
References: <1420662748-28129-1-git-send-email-linux@roeck-us.net> <20150107210419.GH5280@linux.vnet.ibm.com>
In-Reply-To: <20150107210419.GH5280@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010721-0021-0000-0000-00000274E58D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.01.2015 um 22:04 schrieb Paul E. McKenney:
> On Wed, Jan 07, 2015 at 12:32:28PM -0800, Guenter Roeck wrote:
>> Commit a91ed664749c ("kernel: tighten rules for ACCESS ONCE") results in a
>> compile failure for sh builds with CONFIG_X2TLB enabled.
>>
>> arch/sh/mm/gup.c: In function 'gup_get_pte':
>> arch/sh/mm/gup.c:20:2: error: invalid initializer
>> make[1]: *** [arch/sh/mm/gup.o] Error 1
>>
>> Replace ACCESS_ONCE with READ_ONCE to fix the problem.
>>
>> Fixes: a91ed664749c ("kernel: tighten rules for ACCESS ONCE")
>> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Applied to my tree, thanks.

Christian

