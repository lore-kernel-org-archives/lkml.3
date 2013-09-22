Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab3IVKzE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 06:55:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51336 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858Ab3IVKzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 06:55:02 -0400
Date: Sun, 22 Sep 2013 12:54:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nick Warne <nick@linicks.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Samsung laptop - missing documentation
Message-ID: <20130922105453.GA28909@pd.tnic>
References: <20130920195939.GA2353@sauron>
 <20130922104023.GA2332@sauron>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130922104023.GA2332@sauron>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22, 2013 at 11:40:23AM +0100, Nick Warne wrote:
> running 3.11.12-rc1, config help refers:
> 
> Documentation/ABI/testing/sysfs-driver-samsung-laptop
> 
> But this is now missing - by design? but I can't find any patch that removed it.

You mean this one:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/ABI/testing/sysfs-driver-samsung-laptop


It is there, maybe check your repo?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
