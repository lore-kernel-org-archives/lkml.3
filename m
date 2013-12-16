Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab3LPAda (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 19:33:30 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:58555 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab3LPAdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 19:33:22 -0500
Message-ID: <1387154000.19078.220.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [BUG] New lockdep trace: v3.13-rc4
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
Date: Sun, 15 Dec 2013 16:33:20 -0800
In-Reply-To: <20131216000714.GN4360@n2100.arm.linux.org.uk>
References: <20131216000714.GN4360@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-16 at 00:07 +0000, Russell King - ARM Linux wrote:
> I just booted 3.13-rc4 on one of my ARM platforms and was greeted by this
> trace.  Maybe caused by 975022310233 which appears to take this lock in
> softirq context.

Yep, this was mentioned earlier, thanks !

http://patchwork.ozlabs.org/patch/301382/


