Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854Ab3DASZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 14:25:52 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:63691 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757452Ab3DASZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 14:25:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6GTArwivZ=UJox_Laww3zE0rccYt2W4tiwAkSGdT6YYg@mail.gmail.com>
References: <1364444885-19751-1-git-send-email-yinghai@kernel.org>
	<1364444885-19751-3-git-send-email-yinghai@kernel.org>
	<CAErSpo7+V8vU8x2=MfZw3V7XsXKzs6qrvv8G=MqrEdUKcyvoTw@mail.gmail.com>
	<CAE9FiQUWL1+EUf2HZ3CXR87vuUCEE5BCLE18ZP2oE6Eo+_Ueiw@mail.gmail.com>
	<CAErSpo6GTArwivZ=UJox_Laww3zE0rccYt2W4tiwAkSGdT6YYg@mail.gmail.com>
Date: Mon, 1 Apr 2013 11:25:50 -0700
X-Google-Sender-Auth: I-f2rkdUn9lGWqmo2lGYUVvUmTU
Message-ID: <CAE9FiQU+LdKtDSQ7J-Hx=JoC=-K8AyPhyOPHTR+54rLwN=DjrA@mail.gmail.com>
Subject: Re: [PATCH 2/2] eisa, PCI: init eisa early before pnp step in
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Whitehead <mwhitehe@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 1, 2013 at 11:15 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> >> Is this a regression?  This must have worked at one time, but it seems
> >> like we've had pnpacpi_init/isapnp_init/pnpbios_init before PCI
> >> drivers for quite a while.
> >
> > Yes.
>
> Do you know when the regression occurred?  If you do, I'll add that
> info to the "stable" tag.

No, I don't.

Looking at the current code, it should be quite before kernel was using git.
as first drivers/Makefile in git already has pnp before eisa.

Do we need to dig before 2.6.12 and 2.4?

Yinghai
