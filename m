Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab3ICQZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:25:52 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:32856 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758133Ab3ICQZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:25:50 -0400
MIME-Version: 1.0
X-Originating-IP: [89.2.206.189]
In-Reply-To: <20130903150226.GA2392@srcf.ucam.org>
References: <1378147630-12471-1-git-send-email-teg@jklm.no> <20130903150226.GA2392@srcf.ucam.org>
From: Tom Gundersen <teg@jklm.no>
Date: Tue, 3 Sep 2013 18:25:28 +0200
Message-ID: <CAG-2HqVK+nH4+AFrBUmr6wp1zfTeUdLArmXxZxC4TwuPSSkKZg@mail.gmail.com>
Subject: Re: [PATCH] input: allow SERIO=m even without EXPERT=y
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 3, 2013 at 5:02 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Mon, Sep 02, 2013 at 08:47:10PM +0200, Tom Gundersen wrote:
>> There is plenty of consumer hardware (e.g., mac books) that does not use
>> AT keyboards or PS/2 mice. It therefore makes sense for distro kernels
>> to build the related drivers as modules to avoid loading them on hardware
>> that does not need them. As such, these options should no longer be protected
>> by EXPERT.
>
> There are systems (although, with luck, only *very* old ones) where the
> modules won't get autoloaded. You should probably mention that in the
> help text.

Good point, if this turns out to be a problem on current hardware
distros probably want to load the modules automatically at boot by
default.

Does this problem only apply to the i8042 module or also atkbd and libps2?

Cheers,

Tom
