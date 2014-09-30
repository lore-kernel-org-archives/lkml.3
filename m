Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbaI3AkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 20:40:19 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:35094 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbaI3AkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 20:40:17 -0400
Message-ID: <1412037611.10874.1.camel@debian-compaq>
Subject: Re: [PATCH] staging: skein: Fixed Conditional white space problems
From: Eric Rost <eric.rost@mybabylon.net>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Greg KH <gregkh@linuxfoundation.org>, jake@lwn.net, antonysaraev@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 29 Sep 2014 19:40:11 -0500
In-Reply-To: <20140928230216.GF23926@titan.lakedaemon.net>
References: <20140928220828.GA12566@localhost>
	 <20140928221445.GA25174@kroah.com>
	 <20140928230216.GF23926@titan.lakedaemon.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >I'll be looking to see that no object
> code has changed (./scripts/objdiff) across your patch series.

Hmm... I'm thinking of digging into it, but I'm not sure the #if's can
be gotten rid of sans object code changes, since its picking codeblocks
in the precompiler stage, right?

