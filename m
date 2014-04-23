Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbaDWFla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:41:30 -0400
Received: from ozlabs.org ([103.22.144.67]:48636 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbaDWFlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:41:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: simon@mungewell.org
Cc: linux-kernel@vger.kernel.org, Simon Wood <simon@mungewell.org>
Subject: Re: [PATCH 3/9] drivers/hid/hid-lg4ff.c: avoid world-writable sysfs files.
In-Reply-To: <9d9a3af40f8a0da293e52610524674c8.squirrel@mungewell.org>
References: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au> <1398137612-9714-4-git-send-email-rusty@rustcorp.com.au> <9d9a3af40f8a0da293e52610524674c8.squirrel@mungewell.org>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 23 Apr 2014 15:04:50 +0930
Message-ID: <87r44ofw1x.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

simon@mungewell.org writes:
>> In line with practice for module parameters, we're adding a build-time
>> check that sysfs files aren't world-writable.
>
> So this is the equivalent of 'chmod 774 ...' rather than 'chmod
> 777...'?

Yep.  Though not sure why it was 777 rather than 666...

> Yep I'm OK with that, however what it the recommended way to make sure
> that the end user is able to send changes to this /sys portal? I asked the
> same question before regarding the led class /sys interface, but never got
> any suggestions.
>
> Signed-off-by: Simon Wood <simon@mungewell.org>

If you need that, we'll need to make an exception.  That's one purpose
of spamming everyone with these changs...

Do you?

Cheers,
Rusty.
