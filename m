Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933803Ab3CYXwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 19:52:17 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:49665 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933781Ab3CYXwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 19:52:16 -0400
MIME-Version: 1.0
In-Reply-To: <5148D5C8.2000701@gmail.com>
References: <kg69ef$vdb$1@ger.gmane.org>
	<CAPM=9ty0Apsk_5v+aguHQMzFhi9A9kMcWb8fXBmWus9Z=tA=JA@mail.gmail.com>
	<5126C3E1.80801@gmail.com>
	<513BACAC.9050800@gmail.com>
	<CA+55aFyOypoeXgBWP0d7KmL3YezmjwEgrB=ntZaZdYjdmFkQpA@mail.gmail.com>
	<20130319195950.GA16828@srcf.ucam.org>
	<CA+55aFy9nbc+9VyCg0BA9E85sRwksQXvu6Wqgurf5omv2mPtZw@mail.gmail.com>
	<5148D5C8.2000701@gmail.com>
Date: Tue, 26 Mar 2013 09:52:14 +1000
Message-ID: <CAPM=9tyYMSsK_2eCNRTx5EsgAQtnvmHxhgPHP3GHPxKUn+wo5w@mail.gmail.com>
Subject: Re: Regression: Screen turns off when booting in EFI mode
From: Dave Airlie <airlied@gmail.com>
To: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Matthew Garrett <mjg@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ben Skeggs <skeggsb@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Because it's the only way to get the PCI ROM in some cases, like on
>>> pretty much all Apples with Radeons. Only using it if we have no other
>>> options probably makes sense, though. Something like this (entirely
>>> untested)?
>>
>> This looks reasonable. Mantas?
>
> It compiles, boots, and even makes the graphics card work again.
> So it looks good to me.

https://bugzilla.redhat.com/show_bug.cgi?id=927451

popped up sounds like a regression caused by this.

Dave.
