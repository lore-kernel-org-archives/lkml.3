Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab3G2R1C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:27:02 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:5996 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab3G2R1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:27:00 -0400
Message-ID: <51F6A5E2.5050100@hp.com>
Date: Mon, 29 Jul 2013 10:26:58 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Artem S. Tashkinov" <t.artem@lycos.com>
CC: stephen@networkplumber.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: A call to revise sockets behaviour
References: <2066879158.39771.1375110634453.JavaMail.mail@webmail09><20130729083519.5d574f16@nehalam.linuxnetplumber.net> <2063167407.40450.1375112877907.JavaMail.mail@webmail09>
In-Reply-To: <2063167407.40450.1375112877907.JavaMail.mail@webmail09>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> A wine developer clearly showed that this option simply doesn't work.
>
> http://bugs.winehq.org/show_bug.cgi?id=26031#c21
>
> Output of strace:
> getsockopt(24, SOL_SOCKET, SO_REUSEADDR, [0], [4]) = 0
> setsockopt(24, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
> bind(24, {sa_family=AF_INET, sin_port=htons(43012), sin_addr=inet_addr("0.
> 0.0.0")}, 16) = -1 EADDRINUSE (Address already in use)

The output of netstat -an didn't by any chance happen to still show an 
endpoint in the LISTEN state for that port number did it?

rick jones

