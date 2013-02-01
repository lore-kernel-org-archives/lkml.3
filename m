Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab3BAIVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 03:21:48 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:47642 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab3BAIVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 03:21:44 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Fri, 1 Feb 2013 09:21:43 +0100
Message-ID: <CA+icZUW5tBotrZT9QtNPao-3rEccohBW8a4diS2nJ+ONgTWLaQ@mail.gmail.com>
Subject: Re: Revert "console: implement lockdep support for console_lock"
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fbdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

people having the fbcon-locking-fixes [1] in their local GIT tree can
revert this change?

commit ff0d05bf73620eb7dc8aee7423e992ef87870bdf
Refs: v3.8-rc5-194-gff0d05b
Author:     Dave Airlie <airlied@gmail.com>
AuthorDate: Thu Jan 31 14:27:03 2013 +1100
Commit:     Dave Airlie <airlied@gmail.com>
CommitDate: Thu Jan 31 15:46:56 2013 +1100

    Revert "console: implement lockdep support for console_lock"

    This reverts commit daee779718a319ff9f83e1ba3339334ac650bb22.

    I'll requeue this after the console locking fixes, so lockdep
    is useful again for people until fbcon is fixed.

    Signed-off-by: Dave Airlie <airlied@redhat.com>

Thanks!

Regards,
- Sedat

[1] http://cgit.freedesktop.org/~airlied/linux/log/?h=fbcon-locking-fixes
