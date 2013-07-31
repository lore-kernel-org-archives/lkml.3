Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab3GaGqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 02:46:36 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:49724 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab3GaGqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 02:46:34 -0400
Message-ID: <1375253182.8289.3.camel@jlt4.sipsolutions.net>
Subject: Re: ROM Patching (was: [PATCH] bluetooth: remove wrong dependency
 for BT_ATH3K)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Hector Palacios <hector.palacios@digi.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "gustavo@padovan.org" <gustavo@padovan.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        mcgrof@do-not-panic.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "surajs@qca.qualcomm.com" <surajs@qca.qualcomm.com>,
        jjohnson@qca.qualcomm.com, Adrian Chadd <adrian@freebsd.org>,
        ddahlby@qca.qualcomm.com, Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 31 Jul 2013 08:46:22 +0200
In-Reply-To: <20130730224809.GN17130@pogo> (sfid-20130731_004858_121899_020F19AB)
References: <1375114325-25498-1-git-send-email-hector.palacios@digi.com>
	 <5438CD3C-E28C-485C-94B8-F743E8B13D4A@holtmann.org>
	 <51F7722E.9050708@digi.com> <20130730205601.GI17130@pogo>
	 <2C94C740-76BA-4058-B0D7-C37D44875CA1@holtmann.org>
	 <20130730224809.GN17130@pogo> (sfid-20130731_004858_121899_020F19AB)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-30 at 15:48 -0700, Luis R. Rodriguez wrote:

> Neat. Perhaps we need something that we can share with 802.11 or other
> hardare I highly doubt we're the only ones patching ROM. Don't we even
> patch up core CPUs? I'm wondering if firmware_class could be expanded to
> support serialized ROM patching. The biggest hurdle I see with splititng
> ROM patching from a single firmware is serializing that, addressing
> revision dependencies and of course kernel dependencies.

I don't really see what you're trying to get it so I arbitrarily picked
this ...

I think "ROM patching" like in BT and 802.11 are two completely
different things. In BT at least you have a common transport to the
device, a more-or-less common command set (HCI) etc. None of that exists
for wireless (today) so trying to find common ground between firmware
(patches) for different 802.11 hardware seems completely futile?

johannes

