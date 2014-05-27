Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbaE0WWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 18:22:17 -0400
Received: from gloria.sntech.de ([95.129.55.99]:38220 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbaE0WWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 18:22:15 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Mark Rutland <mark.rutland@arm.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 2/2] ARM: dts: mvebu: split SolidRun CuBox into variants
Date: Wed, 28 May 2014 00:24:58 +0200
Message-ID: <32589428.8iAxtgFCnl@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <538508A5.2010809@gmail.com>
References: <1401140009-31505-1-git-send-email-sebastian.hesselbarth@gmail.com> <20140527213549.GU8664@titan.lakedaemon.net> <538508A5.2010809@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 27. Mai 2014, 23:50:29 schrieb Sebastian Hesselbarth:
> On 05/27/2014 11:35 PM, Jason Cooper wrote:
> > On Tue, May 27, 2014 at 07:28:09PM +0200, Sebastian Hesselbarth wrote:
> >> On 05/27/2014 06:11 PM, Jason Cooper wrote:
> >>> On Mon, May 26, 2014 at 11:33:29PM +0200, Sebastian Hesselbarth wrote:
> > info.  It may be useful here, but I'd like to hear from the DT
> > maintainers how they want it used.  eg: most popular first, like you
> > have it, or oldest first
> > 
> > dove-cubox-es.dts
> > +--> dove-cubox.dts
> 
> In the cubox case, this is not possible. ES has a misrouted
> card-detection for sdhci, this requires an additional property.
> There is no way to remove a property once it is written down in
> any of the files included. But you know about that already.

dtc knows "/delete-property/" [0], but I may be missing something here.


[0] https://lists.ozlabs.org/pipermail/devicetree-discuss/2012-August/018169.html
