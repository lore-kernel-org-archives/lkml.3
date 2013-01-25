Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab3AYXen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 18:34:43 -0500
Received: from mail-ia0-f170.google.com ([209.85.210.170]:60911 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab3AYXel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 18:34:41 -0500
MIME-Version: 1.0
In-Reply-To: <5102E63E.1020508@psc.edu>
References: <18855.1359138716@turing-police.cc.vt.edu>
	<5102DE61.80804@psc.edu>
	<23149.1359143784@turing-police.cc.vt.edu>
	<5102E63E.1020508@psc.edu>
Date: Fri, 25 Jan 2013 15:34:41 -0800
Message-ID: <CA+mtBx8C1=8CeV9hcD32oPdEOMdqOO_9XszkG1K93+kAfVhegA@mail.gmail.com>
Subject: Re: [Web10g-user] Web10g TCP statistics patch - mainlining into kernel?
From: Tom Herbert <therbert@google.com>
To: rapier <rapier@psc.edu>
Cc: Valdis.Kletnieks@vt.edu, netdev@vger.kernel.org, web10g-user@web10g.org,
        linux-kernel@vger.kernel.org, Dominic Hamon <dominich@google.com>,
        Matt Mathis <mattmathis@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The user side of the list has been pretty quiet to be sure. Most of the
> discussion happens internal to the team. The primary KIS developer is out
> the office until next week but I'll try to make sure he addresses this as
> soon as he can. I agree entirely with the more eyes approach and none of us
> have a lot of ego sunk into the details of the code in and of itself. As
> researchers, more than anything else, we want the concept moved forward. We
> believe, strongly, that having these metrics in the mainline can really do a
> lot to help the entire user community and spur some really neat development.
>
> Chris
>
Hi Chris, Valdis,

This is certainly interesting, and something that we'd really want to
try to get in upstream Linux since it's is so intrusive in the stack
(we have actually done quite a bit of work in this area already that
might be applicable).  Posting patches against davem's net-next branch
seems appropriate and you could certainly post them as RFC to start
some conversation.

Tom

> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
