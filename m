Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161659AbaJaB2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 21:28:32 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:51327 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759601AbaJaB2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 21:28:31 -0400
MIME-Version: 1.0
In-Reply-To: <11875981.eJaWCbGJJT@wuerfel>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
	<2095416.INZmt8AD1y@wuerfel>
	<CAFiDJ59LZSwKBzVuuzfH_5772-BR74EH=d=FeBbWvEXjfpisug@mail.gmail.com>
	<11875981.eJaWCbGJJT@wuerfel>
Date: Fri, 31 Oct 2014 09:28:29 +0800
X-Google-Sender-Auth: iQbGO89gDNF70PpG54lGIZyksnc
Message-ID: <CAFiDJ58AmQuXnziuxtK6b9Ywm8NqDRwTNt3h+V6sXqSjpqD8XQ@mail.gmail.com>
Subject: Re: [PATCH v5 29/29] nios2: Build infrastructure
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 7:33 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 30 October 2014 18:44:37 Ley Foon Tan wrote:
>> >
>> > I don't remember what all of these are, but at least some of them seem
>> > to be concerned with 64-bit division. By convention, we don't provide those
>> > in the Linux kernel but instead require all code to use the do_div()
>> > macro instead.
>> Do you mean kernel doesn't support 64 bit division result for a 32-bit
>> architecture? Because do_div() only support 32-bit division result for
>> 32-bit architecture.
>
> Correct. If you need a full 64-bit division on a 32-bit kernel, the
> assumption is that your driver has a bug.
>
Okay, will remove 64 bit division.

Regards
Ley Foon
