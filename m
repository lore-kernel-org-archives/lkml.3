Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbaDHRUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 13:20:37 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:55057 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757434AbaDHRUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 13:20:32 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Ldo2/P1o4NvvtSYZ0jOWNWixYSXZdrxI=
X-DKIM: OpenDKIM Filter v2.0.1 titan E37E7554FF6
Date: Tue, 8 Apr 2014 13:20:22 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Levente Kurusa <levex@linux.com>
Cc: Teodora =?utf-8?B?QsSDbHXFo8SD?= <teobaluta@gmail.com>,
        David Lang <david@lang.hm>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [RFC] QR encoding for Oops messages
Message-ID: <20140408172022.GC13102@titan.lakedaemon.net>
References: <20140323193839.GY15608@titan.lakedaemon.net>
 <CAAsK9AF8VevpdF-3nLC5sadV4y31cVeVWb5f2E=sV3ROu3Yk4Q@mail.gmail.com>
 <20140401142051.GO28304@titan.lakedaemon.net>
 <alpine.DEB.2.02.1404031353280.14073@nftneq.ynat.uz>
 <20140404151542.GB28334@titan.lakedaemon.net>
 <533EDB15.40305@linux.com>
 <CACV2jQCxfQzRydFD6KizFnquasqtqaz1O_yNnVDBetFA5UryrA@mail.gmail.com>
 <533FC8A6.6050905@linux.com>
 <20140407152003.GF28334@titan.lakedaemon.net>
 <534418C8.6080105@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534418C8.6080105@linux.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 05:42:00PM +0200, Levente Kurusa wrote:
> On 04/07/2014 05:20 PM, Jason Cooper wrote:
> > On Sat, Apr 05, 2014 at 11:11:02AM +0200, Levente Kurusa wrote:
> >> Oh and another suggestion, I think placing it in the bottom-right
> >> corner would be better since then we wouldn't overwrite some of
> >> the timestamps and messages.
> > 
> > The real text is still sent to the (hopefully written to disk) logs.  If
> > a user (or distro) builds with this feature, I would think centered and
> > scaled for ease of scanning would be highest priority.
> 
> Yup, I'll be traveling on the train a lot this week, so I'll
> have plenty of time to implement scaling and centering. Maybe
> we could also implement this:
> 
> qr_oops=center   (center the QR code with scale 1)
> qr_oops=center,3 (center the QR code with scale 3)
> 
> 'center' could also be 'topleft', 'bottomright', etc.
> Or just remain at the KISS rule? (keep it simple)
> 
> Any objections?

KISS. ;-)

Iff we find we need the feature later, we can always add qr_oops_pos or
similar.

thx,

Jason.
