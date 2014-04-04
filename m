Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaDDPMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:12:42 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:11508 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbaDDPMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:12:39 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18cpaYxfX+A3OXp9SnZbbBKkMAvOaHmQOk=
X-DKIM: OpenDKIM Filter v2.0.1 titan 6F1A0551EAD
Date: Fri, 4 Apr 2014 11:12:33 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Levente Kurusa <levex@linux.com>
Cc: Teodora =?utf-8?B?QsSDbHXFo8SD?= <teobaluta@gmail.com>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [RFC] QR encoding for Oops messages
Message-ID: <20140404151233.GA28334@titan.lakedaemon.net>
References: <20140319201838.GA11403@redhat.com>
 <CACV2jQBrKBUmiYRj8L4tvWucGX5U0EqufC8BkSXoKOL1BO-Tuw@mail.gmail.com>
 <20140321132816.GW15608@titan.lakedaemon.net>
 <532DC3D3.9060008@linux.com>
 <CACV2jQBfRdQOyXF80WLoqm08-3VpWZno6UphKKPWmQD2f_yitA@mail.gmail.com>
 <20140323193839.GY15608@titan.lakedaemon.net>
 <CAAsK9AF8VevpdF-3nLC5sadV4y31cVeVWb5f2E=sV3ROu3Yk4Q@mail.gmail.com>
 <20140401142051.GO28304@titan.lakedaemon.net>
 <CACV2jQB3S71eeLRnvDxy0TAm0Zr+s5KHAKCjwBGQv1GJCiNq6Q@mail.gmail.com>
 <CAAsK9AGW+L4GswAEAZeZEcqUDb+H9b=qu98znsM6XSU3B2fuGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAsK9AGW+L4GswAEAZeZEcqUDb+H9b=qu98znsM6XSU3B2fuGw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 10:21:39PM +0200, Levente Kurusa wrote:
...
> Oh and I had an idea of adding a new kernel parameter, something
> like 'qr_oops.*'. (Looking for a better name! :-) )
> Basically, I thought of the following options so far:
> 
> *  qr_oops.disable=1  - disable it
> *  qr_oops.scale=600x600 - scale the qr code so its easier to read
>    with a phone. In my testing I had huge difficulties reading the
>    QR codes, but when scaled to be a bit bigger it worked magically.
>    This might not be so easy to implement this way, but with preset
>    values, i.e. 4x4 squares instead of a pixel, it could work.

oops.qr=0 - disabled
oops.qr=3 - make each QR pixel 3x3 screen pixels.

I've found 3x3 works well for business cards and such.

0.02c...

thx,

Jason.
