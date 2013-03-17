Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab3CQIvL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 04:51:11 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:55148 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab3CQIvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 04:51:07 -0400
MIME-Version: 1.0
In-Reply-To: <CANN689HbCEBUTDr9jLP9XwZiZdsDOAeWKZzT7y8FrmBD3Aa=fA@mail.gmail.com>
References: <1363447412-23804-1-git-send-email-tom.leiming@gmail.com>
	<CANN689HbCEBUTDr9jLP9XwZiZdsDOAeWKZzT7y8FrmBD3Aa=fA@mail.gmail.com>
Date: Sun, 17 Mar 2013 16:51:05 +0800
Message-ID: <CACVXFVMtacYTSN7kvfFtC8uKt3bB_Ka9EwFi60ZLCBumpo=rZQ@mail.gmail.com>
Subject: Re: [PATCH] mm/fremap.c: fix another oops on error path
From: Ming Lei <tom.leiming@gmail.com>
To: Michel Lespinasse <walken@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Tommi Rantala <tt.rantala@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 12:44 PM, Michel Lespinasse <walken@google.com> wrote:
> On Sat, Mar 16, 2013 at 8:23 AM, Ming Lei <tom.leiming@gmail.com> wrote:
>> Since find_vma() may return NULL, so don't dereference the
>> returned 'vma' until it is valid.
>
> Agree this was an issue. This is fixed with commit a2362d24764a.

It is fine if the issue has been fixed, but I didn't see the commit a2362d
or other fix on both linus and next tree.


Thanks,
-- 
Ming Lei
