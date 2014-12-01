Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbaLAV6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:58:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932324AbaLAV6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:58:45 -0500
Message-ID: <547CE48F.3020700@redhat.com>
Date: Mon, 01 Dec 2014 22:58:39 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
CC: linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladislav Yasevich <vyasevich@gmail.com>
Subject: Re: panic in skb_push via sctp
References: <CAP145pgZ2rbALf-Ce=uGc72DBCNXBvkrEPG43VUkSqkpiLuKsA@mail.gmail.com> <547CA719.6060101@redhat.com> <CAP145pggcEUKz3QhDEGdzWZDusPfwJsZ8juqjbRr+8g6RxuJfA@mail.gmail.com> <547CAEA3.3090906@redhat.com> <CAP145pici-xNuvyhdyRdSok_p_1KXvuNKeceMcdaWdEw8VOBuQ@mail.gmail.com> <547CBE0D.8010501@redhat.com> <CAP145picqMB1HTB2A8mf1f_EB-PjSQYKjxM9LC8mOfj0CNmQ7Q@mail.gmail.com>
In-Reply-To: <CAP145picqMB1HTB2A8mf1f_EB-PjSQYKjxM9LC8mOfj0CNmQ7Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 08:17 PM, Robert Święcki wrote:
>>> Not sure, but I run it inside a pid/ipc/uts/etc/user-namespaces where
>>> it operates with a full set of capabilities, so most of the SOCK_RAW
>>> and tunnel-like-creating calls succeed, so maybe..
>>
>>
>> Ok thanks, can you post your .config?
>
> http://alt.swiecki.net/.ksan/.config-sctp

Thanks, so relevant tunneling is enabled that means MAX_HEADER != LL_MAX_HEADER.
