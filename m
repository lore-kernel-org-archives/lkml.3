Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965110Ab3E2ITO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 04:19:14 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:55772 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964872Ab3E2ITL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 04:19:11 -0400
MIME-Version: 1.0
In-Reply-To: <1369815177019-657210.post@n7.nabble.com>
References: <1369815177019-657210.post@n7.nabble.com>
Date: Wed, 29 May 2013 10:19:10 +0200
Message-ID: <CAFLxGvx4v3xNE_rAzRULLbmbJFpaPakCw8Ng7EJKsWLx1b+Xjw@mail.gmail.com>
Subject: Re: definition of sys_access function
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: johnspaul92 <johns@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 10:12 AM, johnspaul92 <johns@ti.com> wrote:
> Where can i find the definition of the sys_access function???
> I tried checking in syscalls.h. But there i found only the declaration.
> Where can i find the definition so that i can understand what that function
> actually does.

Use git grep to find out.
E.g. git grep "SYSCALL_DEFINE[0-9](access"

--
Thanks,
//richard
