Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaJIUQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 16:16:15 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52430 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaJIUQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 16:16:13 -0400
MIME-Version: 1.0
In-Reply-To: <5DD50C84-608E-4A73-B65D-F6369DF7E1D0@osknowledge.org>
References: <20141009190406.GA5428@localhost>
	<CAH6sp9Prq3VVbBGEEgaYACWgKf53_93eq93RhAWbmknw0x95QQ@mail.gmail.com>
	<CAH6sp9MrU7HxYya7jBGHehBXUqey-PLzVDkvfjJbrU5v1P1WyQ@mail.gmail.com>
	<FC674684-FA28-47F3-BB5D-6709D2BFF770@osknowledge.org>
	<CAH6sp9NOOuLT8c3X24SXmWUYLOWK38gsFDQhVXuqHKi+JdxUjA@mail.gmail.com>
	<5DD50C84-608E-4A73-B65D-F6369DF7E1D0@osknowledge.org>
Date: Thu, 9 Oct 2014 22:16:11 +0200
Message-ID: <CAH6sp9Mgyu8xFSM4Morux7YUDToYA2DHJs5hcE-hPVygGWFqpA@mail.gmail.com>
Subject: Re: acpitool - /proc/acpi/wakeup
From: Frans Klaver <fransklaver@gmail.com>
To: Marc Burkhardt <marc@osknowledge.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2014 at 9:58 PM, Marc Burkhardt <marc@osknowledge.org> wrote:
>
>
>>On Thu, Oct 9, 2014 at 9:42 PM, Marc Burkhardt <marc@osknowledge.org>
>>wrote:
>>> I upgraded from 3.10 on that machine. 3.12 didn't work for me due to
>>a hibernation bug. The rest was left out...  :/
>>
>>If you still have the 3.12 kernel around, could you test if acpitool
>>-e worked there?
>
> Let me ask you a question: does it make sense to test 3.12 again because you know there's something changed regarding /proc/acpi/... or because it's the kernel I broke up on upgrading?

Never mind. It broke after 3.14. I'll bisect.

Frans
