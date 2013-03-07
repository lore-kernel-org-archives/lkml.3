Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341Ab3CGQoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 11:44:20 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:53937 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab3CGQoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 11:44:19 -0500
MIME-Version: 1.0
In-Reply-To: <20130307163743.GC6115@beaver>
References: <20130209141029.GA13493@beaver>
	<1360422473.6696.28.camel@edumazet-glaptop>
	<20130307125424.GI13493@beaver>
	<1362673223.15793.215.camel@edumazet-glaptop>
	<20130307163743.GC6115@beaver>
Date: Thu, 7 Mar 2013 17:44:15 +0100
Message-ID: <CAFLxGvyTA_mGFRb--GTPWvyQ3SDHXrXQksHFNQmjdb-xeVW_Wg@mail.gmail.com>
Subject: Re: BUG: soft lockup on all kernels after 2.6.3x
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Alexey Vlasov <renton@renton.name>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 5:37 PM, Alexey Vlasov <renton@renton.name> wrote:
> On Thu, Mar 07, 2013 at 08:20:23AM -0800, Eric Dumazet wrote:
>>
>> What are gr_xxxx symbols ?
>
> This is grsecurity patches ;)

Please reproduce without grsec...

-- 
Thanks,
//richard
