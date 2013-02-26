Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab3BZFbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 00:31:51 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:39978 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab3BZFbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 00:31:47 -0500
MIME-Version: 1.0
In-Reply-To: <1781256.mPQbtiUPYR@vostro.rjw.lan>
References: <1663657.ypAtqGpGAq@vostro.rjw.lan>
	<1781256.mPQbtiUPYR@vostro.rjw.lan>
Date: Mon, 25 Feb 2013 21:31:45 -0800
X-Google-Sender-Auth: 3AnKBMqSb0-BGdbXqSizvEql7M4
Message-ID: <CA+55aFyzjN_wMH+2RCEA+aNLY0Z7fn4YU7VOtTALbgngn1+vCw@mail.gmail.com>
Subject: Re: [GIT PULL] ACPI and power management fixes for v3.9-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Dave Jones <davej@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 7:17 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> I wonder if this went unnoticed or there's anything wrong with it or it just
> needs to wait for some more time?

Just going through things slowly. It's merged in my tree now.

Oh, and a request: _please_ don't use unknown TLA's like OPP. This has
become a huge problem, to the point that we have a
"Documentation/power/opp.txt" file THAT NEVER CLEARLY STATES WHAT THE
F*CK OPP ACTUALLY MEANS! What nice "documentation".

Ok, I can look up things like this and find that it is "Operating
Performance Points". At least in this context. But no, it's not some
kind of generic standard, and no, it's not something people should be
expected to know in general. Please stop doing "explanations" of
things that use TLA's like this. And people shouldn't have to even
wonder.

                   Linus
