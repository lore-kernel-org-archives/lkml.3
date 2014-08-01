Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbaHAHOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 03:14:48 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:47176 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaHAHOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 03:14:46 -0400
MIME-Version: 1.0
In-Reply-To: <87oaw5caq1.fsf@x220.int.ebiederm.org>
References: <87oaw5caq1.fsf@x220.int.ebiederm.org>
Date: Fri, 1 Aug 2014 09:14:45 +0200
Message-ID: <CAKPyHN1k80fc0hkg7agMkCMDsb623=Zf-TrpyMiMLvtYEjz3_Q@mail.gmail.com>
Subject: Re: [REVIEW][PATCH 0/4] /proc/thread-self
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-api@vger.kernel.org,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2014 at 2:30 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> This patchset implements /proc/thread-self a magic symlink that
> solves a couple of problems.

shouldn't we keep the 'task' in the name, as it points into the 'task'
directory? And why not mimic the current 'self -> <id>' ideom under
/proc/<tgid>/task too and put a new 'self' link there:

$ ls -l /proc/self/task/self
  lrwxrwxrwx 1 root root 0 Aug  1 00:00 /proc/self/task/self -> 484

Bert
