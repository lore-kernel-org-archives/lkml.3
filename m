Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3HBOic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:38:32 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:51123 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842Ab3HBOib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:38:31 -0400
Message-ID: <51FBC463.7040409@linux.vnet.ibm.com>
Date: Fri, 02 Aug 2013 07:38:27 -0700
From: Zach Levis <zml@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.3
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Evgeniy Polyakov <zbr@ioremap.net>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] exec: minor cleanups + minor fix
References: <20130801190455.GA3194@redhat.com> <20130802140916.GA25401@redhat.com>
In-Reply-To: <20130802140916.GA25401@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080214-5806-0000-0000-00002248E2CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 07:09 AM, Oleg Nesterov wrote:
> On 08/01, Oleg Nesterov wrote:
>>
>> Andrew,
>>
>> By discussion with Zach, please drop
>>
>> 	fs-binfmts-add-a-name-field-to-the-binfmt-struct.patch
>> 	fs-binfmts-better-handling-of-binfmt-loops.patch
>> 	fs-binfmts-whitespace-fixes-with-scripts-cleanfile.patch
>>
>> Zach is working on v2.
>>
>> Meanwhile, can't we cleanup search_binary_handler() a bit? It
>> doesn't look nice imho. And we can certainly cleanup it more
>> (perhaps I'll try tomorrow). The error handling, request_module()
>> logic and even "for (try=0; try<2; try++)" looks horrible imho.
>
> Seriously, I think this should be cleanuped too.
>
> Zach, I am sorry if you already rebased your changes, I'll send
> a couple more patches today.
>
Don't worry -- I've been holding off on sending v2 for your changes 
today. It's not much git wrangling to apply your additional patches anyway.

> Oleg.
>

