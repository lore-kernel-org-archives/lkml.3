Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363Ab3E3E7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 00:59:51 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:59181 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab3E3E7p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 00:59:45 -0400
Date: Wed, 29 May 2013 23:59:42 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: definition of sys_access function
To: johnspaul92 <johns@ti.com>
Cc: linux-kernel@vger.kernel.org
References: <1369815177019-657210.post@n7.nabble.com>
In-Reply-To: <1369815177019-657210.post@n7.nabble.com> (from johns@ti.com on
	Wed May 29 03:12:57 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1369889982.2776.48@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 03:12:57 AM, johnspaul92 wrote:
> Where can i find the definition of the sys_access function???
> I tried checking in syscalls.h. But there i found only the  
> declaration.
> Where can i find the definition so that i can understand what that  
> function
> actually does.

$ find linux -name "*.c" | xargs grep SYSCALL | grep '(access'
linux/fs/open.c:SYSCALL_DEFINE2(access, const char __user *, filename,  
int, mode)

Rob