Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab3AOU5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 15:57:07 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:28855 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751762Ab3AOU5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 15:57:06 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX184s2RtUHo5B98mNJN1+/n5Hi5x+URdFs4=
Date: Tue, 15 Jan 2013 15:57:00 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Cong Ding <dinggnu@gmail.com>, Mike Turquette <mturquette@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] clk: mvebu/clk-cpu.c: fix memory leakage
Message-ID: <20130115205700.GE25500@titan.lakedaemon.net>
References: <1358183892-28928-1-git-send-email-dinggnu@gmail.com>
 <50F563EC.3030804@free-electrons.com>
 <20130115152307.GA25615@gmail.com>
 <20130115153716.GF13433@titan.lakedaemon.net>
 <50F584F5.6030007@free-electrons.com>
 <20130115182629.GB7211@gmail.com>
 <50F5A1A9.2030803@free-electrons.com>
 <20130115184423.GC7211@gmail.com>
 <50F5C00B.10108@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F5C00B.10108@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 09:46:03PM +0100, Gregory CLEMENT wrote:
> If you prefer, Jason agrees to take it, but you probably didn't notice it,
> because he uses your former(and no more valid) email when he wrote this.

Actually, I caught that after I hit send.  I resent (just to him), so he
should have it in his inbox.

I've also updated my email alias accordingly.

thx,

Jason.
