Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaFLV0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 17:26:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:32811 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaFLV0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 17:26:13 -0400
Message-ID: <539A1AF1.20808@infradead.org>
Date: Thu, 12 Jun 2014 14:26:09 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Documentation: exceptions to what I maintain
References: <5399DF99.2010701@infradead.org> <1402594501.12385.10.camel@joe-AO725>
In-Reply-To: <1402594501.12385.10.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/14 10:35, Joe Perches wrote:
> On Thu, 2014-06-12 at 10:12 -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <rdunlap@infradead.org>
>>
>> Note that I don't maintain Documentation/ABI/,
>> Documentation/devicetree/, or the language translation files.
>>
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> 
> Hey Randy.
> 
> Perhaps it's better to use exclusion "X:" values
> so get_maintainer doesn't still include you.
> 
>> @@ -2885,7 +2885,7 @@ M:	Randy Dunlap <rdunlap@infradead.org>
>>  L:	linux-doc@vger.kernel.org
>>  T:	quilt http://www.infradead.org/~rdunlap/Doc/patches/
>>  S:	Maintained
>> -F:	Documentation/
>> +F:	Documentation/ (but not: ABI, devicetree, translations)
> 
> Maybe:
> 
> X:	Documentation/ABI/
> X:	Documentation/devicetree/
> X:	Documentation/[a-z][a-z]_[A-Z][A-Z]/
> 
> The last line matches:
> 
> Documentation/ja_JP/
> Documentation/ko_KR/
> Documentation/zh_CN/
> 
> and it's easy to add any other directory you don't
> want to cc'd on.

Hi Joe,

New patch on the way.  Thanks for your help.


-- 
~Randy
