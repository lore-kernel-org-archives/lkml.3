Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647Ab3CSUUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:20:18 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:59858 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757453Ab3CSUUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:20:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130319195950.GA16828@srcf.ucam.org>
References: <kg69ef$vdb$1@ger.gmane.org>
	<CAPM=9ty0Apsk_5v+aguHQMzFhi9A9kMcWb8fXBmWus9Z=tA=JA@mail.gmail.com>
	<5126C3E1.80801@gmail.com>
	<513BACAC.9050800@gmail.com>
	<CA+55aFyOypoeXgBWP0d7KmL3YezmjwEgrB=ntZaZdYjdmFkQpA@mail.gmail.com>
	<20130319195950.GA16828@srcf.ucam.org>
Date: Tue, 19 Mar 2013 13:20:15 -0700
X-Google-Sender-Auth: LNwBCgwDB6hYwrP_amtEFNqtd9U
Message-ID: <CA+55aFy9nbc+9VyCg0BA9E85sRwksQXvu6Wqgurf5omv2mPtZw@mail.gmail.com>
Subject: Re: Regression: Screen turns off when booting in EFI mode
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Dave Airlie <airlied@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 12:59 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
> Because it's the only way to get the PCI ROM in some cases, like on
> pretty much all Apples with Radeons. Only using it if we have no other
> options probably makes sense, though. Something like this (entirely
> untested)?

This looks reasonable. Mantas?

Trusting the firmware-provided image when we can't find the actual HW
image is quite reasonable. It's the "trust firmware unconditionally"
part that gets my goat.

           Linus
