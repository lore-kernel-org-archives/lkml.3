Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab3ENIKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:10:15 -0400
Received: from mail-ia0-f181.google.com ([209.85.210.181]:40178 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab3ENIKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:10:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130507080455.GF20562@intel.com>
References: <1367831854-31952-1-git-send-email-adrian.hunter@intel.com>
	<CACRpkdYsMwAZSw9McHQE4VSsS7wUWLm+mtR1yLzdPCaQzDUo3A@mail.gmail.com>
	<5188A6A0.3040603@intel.com>
	<20130507080455.GF20562@intel.com>
Date: Tue, 14 May 2013 10:10:10 +0200
Message-ID: <CACRpkdZp7pjT4be62_Mf1Evdrim7mOL2GcZxXf8CE2x_=XJS+w@mail.gmail.com>
Subject: Re: [PATCH 0/3] mmc: sdhci: support runtime PM for BYT SD cards
From: Linus Walleij <linus.walleij@linaro.org>
To: "Westerberg, Mika" <mika.westerberg@intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 10:04 AM, Westerberg, Mika
<mika.westerberg@intel.com> wrote:
> On Tue, May 07, 2013 at 10:00:48AM +0300, Adrian Hunter wrote:

>> It would be simpler if the above 2 ACPI GPIO patches made it to 3.10 or went via the mmc tree.
>> Adding Rafael in case he can still take them for 3.10.
>
> Looks like Linus pulled GPIO changes already. So they should be available
> for 3.10.

Yes it appears he (the other Linus) changed his mind, that's fine then...

Yours,
Linus Walleij
