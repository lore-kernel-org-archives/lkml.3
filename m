Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbaDVQaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:30:23 -0400
Received: from host171.canaca.com ([67.55.55.225]:54644 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188AbaDVQaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:30:21 -0400
Message-ID: <9d9a3af40f8a0da293e52610524674c8.squirrel@mungewell.org>
In-Reply-To: <1398137612-9714-4-git-send-email-rusty@rustcorp.com.au>
References: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au>
    <1398137612-9714-4-git-send-email-rusty@rustcorp.com.au>
Date: Tue, 22 Apr 2014 12:30:19 -0400
Subject: Re: [PATCH 3/9] drivers/hid/hid-lg4ff.c: avoid world-writable sysfs
 files.
From: simon@mungewell.org
To: "Rusty Russell" <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, "Rusty Russell" <rusty@rustcorp.com.au>,
        "Simon Wood" <simon@mungewell.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In line with practice for module parameters, we're adding a build-time
> check that sysfs files aren't world-writable.

So this is the equivalent of 'chmod 774 ...' rather than 'chmod 777...'?

Yep I'm OK with that, however what it the recommended way to make sure
that the end user is able to send changes to this /sys portal? I asked the
same question before regarding the led class /sys interface, but never got
any suggestions.

Signed-off-by: Simon Wood <simon@mungewell.org>


