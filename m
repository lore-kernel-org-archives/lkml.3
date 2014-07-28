Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaG1ObG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:31:06 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:51613 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbaG1ObC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:31:02 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+dGaQ1d4pLTJtqL0PDsEacH4mFXlNDi74=
X-DKIM: OpenDKIM Filter v2.0.1 titan F31B75B8657
Date: Mon, 28 Jul 2014 10:30:42 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Benoit Masson <benoitm@perenite.com>
Cc: Benoit Masson <yahoo@perenite.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, gregory.clement@free-electrons.com,
        sebastian.hesselbarth@googlemail.com
Subject: Re: [PATCH 2/2] V4 ARM: mvebu: Added dts defintion for Lenovo
 Iomega ix4-300d NAS
Message-ID: <20140728143042.GS23220@titan.lakedaemon.net>
References: <1406503839-4662-1-git-send-email-yahoo@perenite.com>
 <20140728140805.GQ23220@titan.lakedaemon.net>
 <02CE8576-5CD8-4AA5-971E-85CBC8CE05D3@perenite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02CE8576-5CD8-4AA5-971E-85CBC8CE05D3@perenite.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benoit,

On Mon, Jul 28, 2014 at 04:13:59PM +0200, Benoit Masson wrote:
> Just one question is how would you link this patch to the quirk a0
> patch since this patch can't work without it ...

Even though both patches are needed to boot successfully, there is no
dependency between them in order to compile.  So, they will live in
separate branches until those branches get merged together in a final
release.

The code changes will be applied as a fix to v3.16, and the dts change
will, hopefully, make it in to v3.17.  Where v3.17 will already contain
the code fixes.

thx,

Jason.
