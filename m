Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaADF3i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 00:29:38 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:57259 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaADF3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 00:29:36 -0500
Date: Fri, 3 Jan 2014 21:29:33 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: linux-input@vger.kernel.org, Chris Healy <chealy@imsco-us.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: ims-pcu - fix error unwinding path in application
 mode
Message-ID: <20140104052933.GA32576@core.coreip.homeip.net>
References: <20140104050058.GA20652@core.coreip.homeip.net>
 <CAHQ1cqGZT7TOCX+5yPhWt1MpsSbAfbr07SProgSxrn7RO=7aig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHQ1cqGZT7TOCX+5yPhWt1MpsSbAfbr07SProgSxrn7RO=7aig@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 09:13:10PM -0800, Andrey Smirnov wrote:
> Dmitry,
> 
> Do you want this patch to go separatly or do you want me to bundle it
> with my other changes(probably the first one)?

I'll apply it separately.

> Also, offtopic, do you want me to backport this changes to 2.6 kernel
> that IMS uses or would you do it?

It should apply as is, no backport needed as far as I can tell.

-- 
Dmitry
