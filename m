Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281AbaGNUtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:49:13 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:35839 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117AbaGNUtL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:49:11 -0400
MIME-Version: 1.0
In-Reply-To: <877g3fsm98.fsf@nemi.mork.no>
References: <87pph8kse7.fsf@nemi.mork.no>
	<53C3D7C3.7090505@redhat.com>
	<CA+55aFxYYKApOC+1TQkoxSzi-zTSB8OmkU=ypvNb_Gc2+K6Hmw@mail.gmail.com>
	<CA+55aFzHo4BEO8W0yza7g0YMgg-b=hPbk20-vpR3s==ydpmAOg@mail.gmail.com>
	<877g3fsm98.fsf@nemi.mork.no>
Date: Mon, 14 Jul 2014 13:49:10 -0700
X-Google-Sender-Auth: ouq80A5k-5EEVuNeklWU39baX28
Message-ID: <CA+55aFztNg4aFUnmqxoR-Hwva87D1TMOZ2Gyy8CVmEov9ToDQg@mail.gmail.com>
Subject: Re: [BISECTED 3.16-rc REGREGRESSION] backlight control stopped working
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 1:45 PM, Bjørn Mork <bjorn@mork.no> wrote:
>> brightness change from user mode comes in during that delay, we cancel
>> the kernel-induced pending change.
>
> That sounds like a good solution to me FWIW.

Try the patch. It *might* work. I'm not saying it will, but it seemed
to at least compile for me.

           Linus
