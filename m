Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab3H3OlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 10:41:22 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:55748 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab3H3OlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 10:41:21 -0400
Message-ID: <5220AF0C.4020106@gmail.com>
Date: Fri, 30 Aug 2013 23:41:16 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: dm-devel@redhat.com
CC: gregkh@linuxfoundation.org, mpatocka@redhat.com,
        linux-kernel@vger.kernel.org, agk@redhat.com,
        kernelnewbies@kernelnewbies.org
Subject: Re: [dm-devel] [RFC] dm-lc: plan to go to staging
References: <521EA567.1070801@gmail.com> <20130829020555.GA26206@kroah.com> <20130829033023.GH4872@agk-dp.fab.redhat.com> <alpine.LRH.2.02.1308291043410.20142@file01.intranet.prod.int.rdu2.redhat.com> <52209119.3070907@gmail.com> <20130830125014.GD12181@agk-dp.fab.redhat.com>
In-Reply-To: <20130830125014.GD12181@agk-dp.fab.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (Within the codebase, the filename and module name would still need the
> prefix: we use this for auto-module loading, function name/error message
> scoping etc.)

>> 3) writeboost or wboost
>> Concentrating on the characteristic b)
>> but doesn't mention cache.
> 
> I quite like that option.

OK,
I would like to rename from dm-lc to dm-writeboost.
Do you agree?

Akira

On 8/30/13 9:50 PM, Alasdair G Kergon wrote:
> On Fri, Aug 30, 2013 at 09:33:29PM +0900, Akira Hayakawa wrote:
>> I have three candidates on my mind.
>> I am thinking of removing the dm- prefix as bcache and enhanceio do.
>  
> Yes, that's fine for the general way of referring to this.
> (Within the codebase, the filename and module name would still need the
> prefix: we use this for auto-module loading, function name/error message
> scoping etc.)
> 
>>    a) It writes in-coming writes in log-structured manner.
>>    b) It is extremely fast in write.
>>    c) It is caching software.
> 
> Another candidate: 'lcache' - contrast with 'bcache
>  
>> 3) writeboost or wboost
>> Concentrating on the characteristic b)
>> but doesn't mention cache.
> 
> I quite like that option.
> 
> Alasdair
> 

