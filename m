Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbaGIBNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 21:13:19 -0400
Received: from ozlabs.org ([103.22.144.67]:51047 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbaGIBNR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 21:13:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Michal Nazarewicz <mina86@mina86.com>, Andi Kleen <ak@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH] scripts: modpost: fix compilation warning
In-Reply-To: <1402666754-5325-1-git-send-email-mina86@mina86.com>
References: <1402666754-5325-1-git-send-email-mina86@mina86.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 09 Jul 2014 10:39:04 +0930
Message-ID: <87fvib5oen.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Nazarewicz <mina86@mina86.com> writes:
> The scripts/mod/modpost.c triggers the following warning:
>
> scripts/mod/modpost.c: In function ‘remove_dot’:
> scripts/mod/modpost.c:1710:10: warning: ignoring return value of ‘strtoul’, declared with attribute warn_unused_result [-Wunused-result]

That's a stupid warning, but your improvement is appreciated.

Applied,
Rusty.
