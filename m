Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbaIZU4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:56:24 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:63779 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674AbaIZU4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:56:22 -0400
Message-ID: <5425D2F0.2050207@gmail.com>
Date: Fri, 26 Sep 2014 14:56:16 -0600
From: David Ahern <lxhacker68@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: nicolas.dichtel@6wind.com, Cong Wang <cwang@twopensource.com>,
        netdev <netdev@vger.kernel.org>, containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org, David Miller <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH net-next v2 0/5] netns: allow to identify peer netns
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>	<CAHA+R7NnBJ=T3sukzzp-OD2am1nd318XbrXCX84LfSL=nu9ojw@mail.gmail.com>	<54228D87.3070309@6wind.com>	<CAHA+R7NfJYzCsZx0E9YVXKVCQbCm_thPSi+80tix8Z9nVA82Ug@mail.gmail.com>	<5422F0F4.6000709@6wind.com>	<CAHA+R7Ot2kLHb+ne5AW3bFNc87qkFOiEHEyDh9sFrsHqXgrY3g@mail.gmail.com>	<5423D80B.9060500@6wind.com>	<CAHA+R7Ooyam2L-QfP-TjMEZEOqrQcQDxYiebmw760kgEji4G=g@mail.gmail.com>	<54256CCB.4000709@6wind.com> <5425BB3E.10700@gmail.com>	<87mw9myy4n.fsf@x220.int.ebiederm.org> <5425C22F.7050301@gmail.com> <87tx3uun4q.fsf@x220.int.ebiederm.org>
In-Reply-To: <87tx3uun4q.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/26/14, 2:45 PM, Eric W. Biederman wrote:
> Ah.  You are talking about a system with 2k namespaces and 20-50
> services providing services in all 2k namespaces. Something completely
> different than the case of quagga you mentioned earlier.

Not at all. The earlier quagga example was a starting point on the 
bigger topic -- inefficiencies of namespaces as VRFs. In all of the 
products I have worked on there is always more than 1 service running on 
the system.

> But again this has nothing do with the peer netns work.  So if you have
> something practical to contribute please start a new thread.

Sure, I'll start a new thread.

Thanks,
David
