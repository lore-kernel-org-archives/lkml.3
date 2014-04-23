Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbaDWFl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:41:29 -0400
Received: from ozlabs.org ([103.22.144.67]:47965 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385AbaDWFlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:41:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ryan Nicholl <r.p.nicholl@gmail.com>, linux-kernel@vger.kernel.org
Cc: Ryan Nicholl <r.p.nicholl@gmail.com>
Subject: Re: Futex Question (64 bits?)
In-Reply-To: <CAPuLQKxoc3Gk3_xKetSOzFLg5s36P3MJ7Jy=15_JmwYp2J_v+g@mail.gmail.com>
References: <CAPuLQKxoc3Gk3_xKetSOzFLg5s36P3MJ7Jy=15_JmwYp2J_v+g@mail.gmail.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 23 Apr 2014 14:58:28 +0930
Message-ID: <87tx9kfwcj.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryan Nicholl <r.p.nicholl@gmail.com> writes:
> I would like to know if it would be possible to use a 64 bit futex
> call? If not, I would like to request it be added. (It is acknowledged
> in the manpages that it must be added eventually anyway.)

It could be done; it's just not been done yet.

Simple matter of coding ;)

Cheers,
Rusty.
