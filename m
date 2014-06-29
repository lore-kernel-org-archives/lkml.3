Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbaF2VY0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 17:24:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48972 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbaF2VYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 17:24:25 -0400
Date: Sun, 29 Jun 2014 23:24:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nick Warne <nick@linicks.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.15.2 build error on AMD64
Message-ID: <20140629212423.GE12943@pd.tnic>
References: <53AE9058.50902@linicks.net>
 <20140628101240.GA6357@pd.tnic>
 <53AE9863.6050102@linicks.net>
 <53AE9F0B.1080207@linicks.net>
 <20140628122322.GC4373@pd.tnic>
 <53AEBE75.9070301@linicks.net>
 <53B063BC.4040200@linicks.net>
 <20140629194403.GB12943@pd.tnic>
 <53B07F99.40600@linicks.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53B07F99.40600@linicks.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2014 at 10:05:29PM +0100, Nick Warne wrote:
> Thanks Boris, but unfortunately I had to trash GCC 4.2.4 to build the
> new 4.7.4 version - so I can't test the patch :(
>
> At least this issue is now on record so others will not need to go to
> penalties.

I hope so.

Btw, I thought you had that gcc 4.2.x from some distro or so. Because if
it is in some ancient distro, one could install it in kvm and test and
play with it.

Maybe I should go dig some old distro and play with it nevertheless -
issues like that tend to pop up off and on.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
