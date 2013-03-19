Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934270Ab3CSVRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 17:17:05 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:44853 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933560Ab3CSVRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 17:17:03 -0400
Message-ID: <5148D5C8.2000701@gmail.com>
Date: Tue, 19 Mar 2013 23:16:56 +0200
From: =?UTF-8?B?TWFudGFzIE1pa3VsxJduYXM=?= <grawity@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Matthew Garrett <mjg@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Dave Airlie <airlied@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Regression: Screen turns off when booting in EFI mode
References: <kg69ef$vdb$1@ger.gmane.org> <CAPM=9ty0Apsk_5v+aguHQMzFhi9A9kMcWb8fXBmWus9Z=tA=JA@mail.gmail.com> <5126C3E1.80801@gmail.com> <513BACAC.9050800@gmail.com> <CA+55aFyOypoeXgBWP0d7KmL3YezmjwEgrB=ntZaZdYjdmFkQpA@mail.gmail.com> <20130319195950.GA16828@srcf.ucam.org> <CA+55aFy9nbc+9VyCg0BA9E85sRwksQXvu6Wqgurf5omv2mPtZw@mail.gmail.com>
In-Reply-To: <CA+55aFy9nbc+9VyCg0BA9E85sRwksQXvu6Wqgurf5omv2mPtZw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-03-19 22:20, Linus Torvalds wrote:
> On Tue, Mar 19, 2013 at 12:59 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>>
>> Because it's the only way to get the PCI ROM in some cases, like on
>> pretty much all Apples with Radeons. Only using it if we have no other
>> options probably makes sense, though. Something like this (entirely
>> untested)?
> 
> This looks reasonable. Mantas?

It compiles, boots, and even makes the graphics card work again.
So it looks good to me.

-- 
Mantas Mikulėnas <grawity@gmail.com>
