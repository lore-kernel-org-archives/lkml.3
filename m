Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab3GMICS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 04:02:18 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43213 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201Ab3GMICO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 04:02:14 -0400
Date: Sat, 13 Jul 2013 10:01:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: Alexandru Juncu <alexj@rosedu.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Script for isolating maintainer email.
Message-ID: <20130713080153.GA5502@pd.tnic>
References: <1373701241-6499-1-git-send-email-alexj@rosedu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1373701241-6499-1-git-send-email-alexj@rosedu.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 13, 2013 at 10:40:41AM +0300, Alexandru Juncu wrote:
> Hello!
> 
> I found the need for a script that doesn't require me to copy part of the
> output from get_maintainer.pl into git send-email and could do both with
> one command.

What's wrong with adding this to get_maintainer.pl itself? I.e.,

git send-email --cc-cmd=./scripts/get_maintainer.pl my.patch ...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
