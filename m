Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbaGWPPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:15:44 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:51874 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbaGWPPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:15:41 -0400
Date: Wed, 23 Jul 2014 17:10:33 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Jason Cooper <jason@lakedaemon.net>
Cc: benoitm974 <yahoo@perenite.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, benoitm@perenite.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] Adding lenovo in vendor
Message-ID: <20140723151033.GF2856@lunn.ch>
References: <1406117232-5962-1-git-send-email-yahoo@perenite.com>
 <1406117232-5962-2-git-send-email-yahoo@perenite.com>
 <20140723134756.GG23220@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140723134756.GG23220@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +lenovo	LENOVO
> 
> is this their official, registered company name?

http://www.lenovo.com/ww/lenovo/FAQs.html says

1. What is Lenovo’s stock symbol (ticker)?
HKSE: 992.hk
ADR (Level I): LNVGY

So i think lenovo is probably the more understandable vendor prefix,
even if it is not the official stock ticker.

However there official registered company name appears to be
Lenovo Group Limited.

       Andrew
