Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762085Ab3JQBIC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 21:08:02 -0400
Received: from intranet.asianux.com ([58.214.24.6]:27136 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761013Ab3JQBIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 21:08:00 -0400
X-Spam-Score: -100.8
Message-ID: <525F3830.2060001@asianux.com>
Date: Thu, 17 Oct 2013 09:06:56 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: josh@freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/rcutorture.c: use scnprintf() instead of sprintf()
References: <5253C335.5050609@asianux.com> <20131013110518.GC5790@linux.vnet.ibm.com> <525BAD9F.6060406@asianux.com> <20131014112839.GO5790@linux.vnet.ibm.com> <525C9256.5010002@asianux.com> <525C9FAE.4090209@asianux.com> <20131015082613.GG5790@linux.vnet.ibm.com> <525D35E9.3000604@asianux.com> <20131015144732.GG9150@linux.vnet.ibm.com> <525DF4F0.3070901@asianux.com>
In-Reply-To: <525DF4F0.3070901@asianux.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 10:07 AM, Chen Gang wrote:
> On 10/15/2013 10:47 PM, Paul E. McKenney wrote:
>> > On Tue, Oct 15, 2013 at 08:32:41PM +0800, Chen Gang wrote:
>>> >> Yeah, that is a way for it. It seems you (related maintainer) like
>>> >> additional fix for it.
>>> >>
>>> >> Hmm... I will try within this week (although I don't think it is quite
>>> >> necessary to me).
>>> >>
>>> >> :-)
>> > 
>> > If you always ensure that the buffer is big enough, do you really need
>> > the checking?
>> > 
> Since they are all normal static functions: Of cause not need length
> checking, either don't need return value, either don't need local
> variable 'cnt'.
> 

2 information:

 - this way (base on nr_cpu_ids, not snprintf) is not extensible.
   when add new printing contents, need modify maximized length.
   if acceptable to you, I will go (or do you have any new ideas?).

 - sorry, I have some internal urgent things to do, so may not finish
   within this week, and I will finish it in this month (2013-10-31).


Thanks.
-- 
Chen Gang
