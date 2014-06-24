Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaFXLrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 07:47:25 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:22220 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751530AbaFXLrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 07:47:24 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18kpnJd3N1pETIL+P/FpMY+w5ECvnJRxlI=
X-DKIM: OpenDKIM Filter v2.0.1 titan 0C6BA5982A6
Date: Tue, 24 Jun 2014 07:46:47 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        sergei.shtylyov@cogentembedded.com,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: mvebu: Fix the improper use of the compatible
 string armada38x using a wildcard
Message-ID: <20140624114647.GI10202@titan.lakedaemon.net>
References: <1403533011-21339-1-git-send-email-gregory.clement@free-electrons.com>
 <20140623215309.GD10202@titan.lakedaemon.net>
 <53A92EEF.6070803@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A92EEF.6070803@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 09:55:27AM +0200, Gregory CLEMENT wrote:
> Hi Jason,
> 
> >> This fix should be merged in 3.16 and maybe sent as a fix for 3.15
> >> too.
> 
> [...]
> 
> > Applied to mvebu/dt with Andrew's Ack.
> 
> I think it should go mvebu/fixes as this patch modifies the binding,
> sooner is better.

oops.  Yeah, I f'd that up.  Sorry.  Fixed now.  I've Cc'd stable for
v3.15+

thx,

Jason.
