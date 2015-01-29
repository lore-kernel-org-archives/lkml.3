Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731AbbA2KEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:04:32 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:63673 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530AbbA2KE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:04:27 -0500
Date: Thu, 29 Jan 2015 11:04:24 +0100
From: Johan Hovold <johan@kernel.org>
To: Peter Hung <hpeter@gmail.com>
Cc: Johan Hovold <johan@kernel.org>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom_tsai@fintek.com.tw, peter_hong@fintek.com.tw,
        Peter Hung <hpeter+linux_kernel@gmail.com>
Subject: Re: [PATCH v3 1/5] usb: serial: add register map for F81232
Message-ID: <20150129100424.GB5312@localhost>
References: <1422424676-7395-1-git-send-email-hpeter+linux_kernel@gmail.com>
 <20150128175525.GE2433@localhost>
 <54C99CEE.8070802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C99CEE.8070802@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2015 at 10:37:34AM +0800, Peter Hung wrote:
> Hello.
> 
> 1. For retry Issue:
> 
> These patches is referenced from our other usb serial product. That 
> product maybe not ack the control ep command when It's in very heavily 
> loading. Our workaround is to modify driver to retry more times if it 
> timeout because it's f/w can't upgrade with usb protocol. I will remove 
> the retry mechanic and test for it again.

That sounds good.

> 2. For some function/variable not used:
> 
> The original driver is lacking a lot of feature. My first patch strategy 
> is putting all needed function / variables in patch 1 and apply it in 
> following patches. Sorry for my wrong strategy, I'll change it with more 
> meaningful and logical patchset and resend it.

Perhaps you just need to break the patches up further.

Also if you get checkpatch warnings for code you haven't touched, you
can either ignore them or fix it separately in preparatory patch.

Just try to group related changes together.

> Thanks for your patient and advice.

No worries. 

In the future when posting to the lists, please try to respond inline
(as I am above) rather than top-post, and remove context that isn't
relevant (e.g. code that isn't relevant) for the discussion at hand.

Thanks,
Johan
