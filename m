Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaKDNs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:48:29 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:50465 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaKDNs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:48:28 -0500
MIME-Version: 1.0
In-Reply-To: <4832015.R1NooRni06@vostro.rjw.lan>
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com>
	<20141104082056.GG1618@lahna.fi.intel.com>
	<20141104093907.GH1618@lahna.fi.intel.com>
	<4832015.R1NooRni06@vostro.rjw.lan>
Date: Tue, 4 Nov 2014 14:48:27 +0100
Message-ID: <CACRpkdaZYubzEKVKiG4vCnh2kDr7CfRvaXcJNHSFtSUaRdXW4A@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] pinctrl: Intel Cherryview/Braswell support
From: Linus Walleij <linus.walleij@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Timur Tabi <timur@codeaurora.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Ning Li <ning.li@intel.com>, Alan Cox <alan@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 2:31 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Tuesday, November 04, 2014 11:39:07 AM Mika Westerberg wrote:

>> For reference the latest ACPI _DSD patches can be found here
>>
>> https://lkml.org/lkml/2014/10/21/762
>
> Actually, it's better to pull the device-properties branch:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git device-properties
>
> because that contains the lastest changes.  It will be rebased in the future,
> though, so don't merge it into your "immutable" branches.

I've landed these two patches for v3.19, I guess we can wait for the
device properties to land properly upstream before proceeding
with ACPI support ...? Or are you guys working with one finger
constantly on the fast-forward button? :D

Yours,
Linus Walleij
