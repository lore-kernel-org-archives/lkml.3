Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbaDGPUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 11:20:20 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:51362 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753143AbaDGPUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 11:20:13 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+SmkanntzyaNY+KJRNqFOg2LupDuu93UM=
X-DKIM: OpenDKIM Filter v2.0.1 titan 286FD553BD0
Date: Mon, 7 Apr 2014 11:20:04 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Levente Kurusa <levex@linux.com>
Cc: Teodora =?utf-8?B?QsSDbHXFo8SD?= <teobaluta@gmail.com>,
        David Lang <david@lang.hm>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [RFC] QR encoding for Oops messages
Message-ID: <20140407152003.GF28334@titan.lakedaemon.net>
References: <532DC3D3.9060008@linux.com>
 <CACV2jQBfRdQOyXF80WLoqm08-3VpWZno6UphKKPWmQD2f_yitA@mail.gmail.com>
 <20140323193839.GY15608@titan.lakedaemon.net>
 <CAAsK9AF8VevpdF-3nLC5sadV4y31cVeVWb5f2E=sV3ROu3Yk4Q@mail.gmail.com>
 <20140401142051.GO28304@titan.lakedaemon.net>
 <alpine.DEB.2.02.1404031353280.14073@nftneq.ynat.uz>
 <20140404151542.GB28334@titan.lakedaemon.net>
 <533EDB15.40305@linux.com>
 <CACV2jQCxfQzRydFD6KizFnquasqtqaz1O_yNnVDBetFA5UryrA@mail.gmail.com>
 <533FC8A6.6050905@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533FC8A6.6050905@linux.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 05, 2014 at 11:11:02AM +0200, Levente Kurusa wrote:
> Or, we could use core_param and simply have 'oops_qr' or
> 'qr_oops'. In my humble opinion the latter sounds better.

Ack.  My original suggestion was focused on 0=disable, >0 is scale.  I
literally pulled the name from my nether-regions.  :-)

> Oh and another suggestion, I think placing it in the bottom-right
> corner would be better since then we wouldn't overwrite some of
> the timestamps and messages.

The real text is still sent to the (hopefully written to disk) logs.  If
a user (or distro) builds with this feature, I would think centered and
scaled for ease of scanning would be highest priority.

I don't think there is a 'safe' part of the framebuffer real estate
where the QR could be written for all scenarios.  Best to make it easy
to scan.

thx,

Jason.
