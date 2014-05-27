Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaE0Qie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 12:38:34 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:36027 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751615AbaE0Qic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 12:38:32 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18mAEGWGLhwjOZg7ylv3f90T4U/JQSW7Bs=
X-DKIM: OpenDKIM Filter v2.0.1 titan 26437581010
Date: Tue, 27 May 2014 12:38:11 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: dts: mvebu: split SolidRun CuBox into variants
Message-ID: <20140527163811.GT8664@titan.lakedaemon.net>
References: <1401140009-31505-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1401140009-31505-2-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140527161143.GS8664@titan.lakedaemon.net>
 <5384BDB1.6000107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5384BDB1.6000107@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 06:30:41PM +0200, Sebastian Hesselbarth wrote:
...
> About the board specific compatibles, I am not so sure if we should
> keep them at all. "solidrun,cubox" for all three variants should be
> enough. checkpatch is already choking on every unknown compatible it
> sees and documenting each individual board clearly doesn't scale well.

Yeah, I saw that conversation.  I'm inclined to keep the board
compatible strings because they are a useful human readable globally
unique board identifier.  I suggest we fix checkpatch to not barf on the
board compatible strings.

thx,

Jason.
