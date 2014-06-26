Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbaFZG4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 02:56:39 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49320 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbaFZG4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 02:56:36 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of: Transactional DT support.
To: Dan Malek <dan.malek@konsulko.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        devicetree@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        linux-i2c@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pete Popov <pete.popov@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
In-Reply-To: <2B23E906-3099-4775-B471-58BEB1542A36@konsulko.com>
References: <1403430093-15132-1-git-send-email-pantelis.antoniou@konsulko.com>
	<20140625140641.F10F0C40B59@trevor.secretlab.ca>
	<C0AB3C41-C0BE-4F50-A4DB-843EAC8C8F6F@konsulko.com>
	<2B23E906-3099-4775-B471-58BEB1542A36@konsulko.com>
Date: Thu, 26 Jun 2014 07:56:30 +0100
Message-Id: <20140626065630.626CFC40E5E@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2014 12:20:16 -0700, Dan Malek <dan.malek@konsulko.com> wrote:
> 
> On Jun 25, 2014, at 7:48 AM, Pantelis Antoniou <pantelis.antoniou@konsulko.com> wrote:
> 
> >>> +int of_transaction_commit(struct of_transaction *oft);
> >> 
> >> How about of_transaction_apply()?
> >> 
> > 
> > Sure.
> 
> LOL!  Panto, you give in too easily :)
> 
> Any transaction state diagrams I've seen always have a "commit" phase/state, never anything called "apply."  So, of_transaction_commit() is exactly the proper name.

Hahaha. my suggestiong on name is conditional on my earlier comment to
make the API bulk-change instead of transaction oriented. Commit is
indeed the right name for a transactional model.

g.

