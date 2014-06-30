Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbaF3N0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:26:42 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43923 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbaF3N0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:26:41 -0400
Date: Mon, 30 Jun 2014 15:26:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nick Warne <nick@linicks.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.15.2 build error on AMD64
Message-ID: <20140630132637.GD4766@pd.tnic>
References: <53AE9058.50902@linicks.net>
 <20140628101240.GA6357@pd.tnic>
 <53AE9863.6050102@linicks.net>
 <53AE9F0B.1080207@linicks.net>
 <20140628122322.GC4373@pd.tnic>
 <53AEBE75.9070301@linicks.net>
 <53B063BC.4040200@linicks.net>
 <20140629194403.GB12943@pd.tnic>
 <53B07F99.40600@linicks.net>
 <20140629212423.GE12943@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140629212423.GE12943@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2014 at 11:24:23PM +0200, Borislav Petkov wrote:
> Btw, I thought you had that gcc 4.2.x from some distro or so. Because
> if it is in some ancient distro, one could install it in kvm and test
> and play with it.

Ok, I did dig out an ancient debian I had lying around here with gcc
4.1.2. The patch I pointed you at does really fix the issue. So all is
fine and solved now. :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
