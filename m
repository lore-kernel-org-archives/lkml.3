Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbaCHKpi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 05:45:38 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.149]:58067 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750730AbaCHKpg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 05:45:36 -0500
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-4.tower-180.messagelabs.com!1394275532!29917584!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Joe Perches <joe@perches.com>
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: RE: [RFC V1] MAINTAINERS: Addition of Dialog Semiconductor files
Thread-Topic: [RFC V1] MAINTAINERS: Addition of Dialog Semiconductor files
Thread-Index: AQHPOfq8tg3ORNK1CUy9tJeIqrJ5L5rVz6EAgAExSDA=
Date: Sat, 8 Mar 2014 10:45:30 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB7A0C6C9FD@SW-EX-MBX02.diasemi.com>
References: <201403071145.s27BjBpg020540@swsrvapps-01.diasemi.com>
 <1394209504.16156.70.camel@joe-AO722>
In-Reply-To: <1394209504.16156.70.camel@joe-AO722>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.50.144]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07 March 2014 16:25 Joe Perches wrote:

>> Dialog Semiconductor would like to add a new section called DIALOG
>> SEMICONDUCTOR DRIVERS which contains the new support mailing list
>> <support.opensource@diasemi.com> for Dialog supported drivers.
>
>That's a fine idea.
>
>It's generally better to have a person rather
>than an exploder as a maintainer.
>
>It's also fine to have an exploder listed too.
>

Thanks for your reply Joe,

In the past, mails were sent to Dialog e-mail addresses that were no
longer valid and so the notifications were missed. To rectify this,
we were hoping to avoid personalised e-mail addresses in the
MAINTAINERS file (and at the same time avoid putting individual
entries for all our drivers).

This single e-mail address will deliver a message to all the developers
who can contribute to all the drivers. This support.opensource
address does not allow us to send e-mails, so we will be replying with
our personal accounts.

>
>If "support.opensource@diasemi.com" is actually
>a public mailing list (like linux-kernel), then
>it should use an "L: " entry.
>

I have this wrong then, it is not a 'mailing-list' and so it should not be
identified as "L:". I will replace this with "M:" and then resubmit this
as a PATCH on Monday.. if there are no further comments by then.

>> Regards,
>> Steve Twiss, Dialog Semiconductor Ltd.
>
>Maybe you.

We will still add our personal e-mails to individual files, but we were
hoping that by adding the support.opensource address to just the
MAINTAINERS file, this would allow us to catch developer changes at
our side.

Regards,
Steve
