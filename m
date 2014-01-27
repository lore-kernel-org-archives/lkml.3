Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbaA0Lpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 06:45:53 -0500
Received: from ozlabs.org ([203.10.76.45]:51193 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbaA0Lpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 06:45:51 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jiri Slaby <jslaby@suse.cz>, jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 2/2] module: use pr_cont
In-Reply-To: <1390814884-15519-2-git-send-email-jslaby@suse.cz>
References: <1390814884-15519-1-git-send-email-jslaby@suse.cz> <1390814884-15519-2-git-send-email-jslaby@suse.cz>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 27 Jan 2014 22:07:54 +1030
Message-ID: <871tzt1wq5.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jslaby@suse.cz> writes:
> When dumping loaded modules, we print them one by one in separate
> printks. Let's use pr_cont as they are continuation prints.

Applied.

Thanks,
Rusty.
