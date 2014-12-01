Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbaLATRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:17:40 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:46766 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbaLATRi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:17:38 -0500
MIME-Version: 1.0
In-Reply-To: <547CBE0D.8010501@redhat.com>
References: <CAP145pgZ2rbALf-Ce=uGc72DBCNXBvkrEPG43VUkSqkpiLuKsA@mail.gmail.com>
	<547CA719.6060101@redhat.com>
	<CAP145pggcEUKz3QhDEGdzWZDusPfwJsZ8juqjbRr+8g6RxuJfA@mail.gmail.com>
	<547CAEA3.3090906@redhat.com>
	<CAP145pici-xNuvyhdyRdSok_p_1KXvuNKeceMcdaWdEw8VOBuQ@mail.gmail.com>
	<547CBE0D.8010501@redhat.com>
Date: Mon, 1 Dec 2014 20:17:36 +0100
Message-ID: <CAP145picqMB1HTB2A8mf1f_EB-PjSQYKjxM9LC8mOfj0CNmQ7Q@mail.gmail.com>
Subject: Re: panic in skb_push via sctp
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladislav Yasevich <vyasevich@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Not sure, but I run it inside a pid/ipc/uts/etc/user-namespaces where
>> it operates with a full set of capabilities, so most of the SOCK_RAW
>> and tunnel-like-creating calls succeed, so maybe..
>
>
> Ok thanks, can you post your .config?

Hi,

http://alt.swiecki.net/.ksan/.config-sctp

-- 
Robert Święcki
