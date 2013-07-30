Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789Ab3G3VEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 17:04:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756991Ab3G3VEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 17:04:47 -0400
Date: Tue, 30 Jul 2013 14:04:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zach Levis <zml@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Zach Levis <zach@zachsthings.com>
Subject: Re: [PATCH 2/3] fs/binfmts: Better handling of binfmt loops
Message-Id: <20130730140446.1a4982e21ac8e183c65e9ed1@linux-foundation.org>
In-Reply-To: <1374766845-13565-2-git-send-email-zml@linux.vnet.ibm.com>
References: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com>
	<1374766845-13565-2-git-send-email-zml@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jul 2013 08:40:44 -0700 Zach Levis <zml@linux.vnet.ibm.com> wrote:

> With these changes, when a binfmt loop is encountered,
> the ELOOP will propogate back to the 0 depth. At this point the
> argv and argc values will be reset to what they were originally and an
> attempt is made to continue with the following binfmt handlers.

hm, why?  What problem does this fix?  What value does the change offer
to our users?

