Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaAGRnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:43:33 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:59432 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbaAGRnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:43:23 -0500
MIME-Version: 1.0
In-Reply-To: <1387833287.4412.6.camel@jlt4.sipsolutions.net>
References: <1385460350-17543-1-git-send-email-mika.westerberg@linux.intel.com>
	<1385460350-17543-3-git-send-email-mika.westerberg@linux.intel.com>
	<CACRpkdb03X_Z7amX-vAVX8KboeCo3ia6oqv8KW79WY=nZXV7wQ@mail.gmail.com>
	<20131223105420.GP8621@intel.com>
	<1387833287.4412.6.camel@jlt4.sipsolutions.net>
Date: Tue, 7 Jan 2014 18:43:22 +0100
Message-ID: <CACRpkdYmSQD8u3ZutYVC=3hAch_ikkPXAcKa6d0o6T+N+QFqGw@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] net: rfkill: gpio: convert to descriptor-based
 GPIO interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>, linux-netdev@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Chris Ball <cjb@laptop.org>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 10:14 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2013-12-23 at 12:54 +0200, Mika Westerberg wrote:
>> On Wed, Dec 11, 2013 at 01:00:18PM +0100, Linus Walleij wrote:
>> > On Tue, Nov 26, 2013 at 11:05 AM, Mika Westerberg
>> > <mika.westerberg@linux.intel.com> wrote:
>> >
>> > > From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>> > >
>> > > Convert to the safer gpiod_* family of API functions.
>> > >
>> > > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>> > > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>> > > Tested-by: Stephen Warren <swarren@nvidia.com>
>>
>> Johannes B, David M,
>>
>> Are you fine with this patch? If yes, could you ack it so that we could get
>> it merged for 3.14.
>
> I have no objection to this particular patch. I can't really comment on
> it, but I never really delved too deeply into the rfkill-gpio thing - I
> guess it works for whoever needed it :)

I take that as an ACK ;-)

Patch applied.

Yours,
Linus Walleij
