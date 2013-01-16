Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab3APVsC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 16:48:02 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:34577 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab3APVsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 16:48:00 -0500
Message-ID: <50F7200E.7000209@gmail.com>
Date: Wed, 16 Jan 2013 16:47:58 -0500
From: Xi Wang <xi.wang@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH RFC] exec: avoid possible undefined behavior in count()
References: <1357450145-23964-1-git-send-email-xi.wang@gmail.com> <20130107134422.038de6f9.akpm@linux-foundation.org>
In-Reply-To: <20130107134422.038de6f9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/7/13 4:44 PM, Andrew Morton wrote:
> I have no problem working around a compiler bug when the workaround is
> so small and simple.  For clarity and accuracy I renamed the patch to
> "fs/exec.c: work around icc miscompilation".

Thanks!

> However I'd also like to be able to add "this bug has been reported to
> the icc developers and will be fixed in version X.Y"?

The icc developers have confirmed this bug and filed a defect ticket.
I'll let you know if there's any further update.

- xi
