Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbbAJUID (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 15:08:03 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:62058 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbbAJUIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 15:08:01 -0500
MIME-Version: 1.0
In-Reply-To: <1420840730.32628.13.camel@perches.com>
References: <1420840730.32628.13.camel@perches.com>
Date: Sat, 10 Jan 2015 14:08:00 -0600
X-Google-Sender-Auth: 2HhLcYTNjPq4Dw4ptnirB6w4cNE
Message-ID: <CAEUsAPb7dHfmEJikk8Xfx1YKrZd3p1vimo_rh3SE4ckqzZShYA@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: Update git commit message
From: Chris Rorvick <chris@rorvick.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Daniel Baluta <daniel.baluta@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2015 at 3:58 PM, Joe Perches <joe@perches.com> wrote:
> The git commit message can be confusing,
>
> Try to clarify the message a bit to reduce
> the confusion when emitted.

I just ignored a few GIT_COMMIT_ID errors last night because I was
confused by the message.  My mistake was forgetting to quote the commit
summary.  Running checkpatch with this makes the problem clear.

Tested-by: Chris Rorvick <chris@rorvick.com>
