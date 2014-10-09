Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375AbaJIT6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:58:37 -0400
Received: from webbox4.loswebos.de ([213.187.93.205]:54567 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaJIT6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:58:35 -0400
In-Reply-To: <CAH6sp9NOOuLT8c3X24SXmWUYLOWK38gsFDQhVXuqHKi+JdxUjA@mail.gmail.com>
References: <20141009190406.GA5428@localhost> <CAH6sp9Prq3VVbBGEEgaYACWgKf53_93eq93RhAWbmknw0x95QQ@mail.gmail.com> <CAH6sp9MrU7HxYya7jBGHehBXUqey-PLzVDkvfjJbrU5v1P1WyQ@mail.gmail.com> <FC674684-FA28-47F3-BB5D-6709D2BFF770@osknowledge.org> <CAH6sp9NOOuLT8c3X24SXmWUYLOWK38gsFDQhVXuqHKi+JdxUjA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: acpitool - /proc/acpi/wakeup
From: Marc Burkhardt <marc@osknowledge.org>
Reply-to: marc@osknowledge.org
Date: Thu, 09 Oct 2014 19:58:30 +0000
To: Frans Klaver <fransklaver@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <5DD50C84-608E-4A73-B65D-F6369DF7E1D0@osknowledge.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>On Thu, Oct 9, 2014 at 9:42 PM, Marc Burkhardt <marc@osknowledge.org>
>wrote:
>> I upgraded from 3.10 on that machine. 3.12 didn't work for me due to
>a hibernation bug. The rest was left out...  :/
>
>If you still have the 3.12 kernel around, could you test if acpitool
>-e worked there?

Let me ask you a question: does it make sense to test 3.12 again because you know there's something changed regarding /proc/acpi/... or because it's the kernel I broke up on upgrading? 

I could compile one, sure. But I have no time to actually 'bisect' this... unfortunately.

Thanks for your support,
Marc

