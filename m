Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaLQPxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 10:53:50 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:35522 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaLQPxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 10:53:48 -0500
MIME-Version: 1.0
In-Reply-To: <1418808435.14140.16.camel@perches.com>
References: <1418801732-19141-1-git-send-email-computersforpeace@gmail.com> <1418808435.14140.16.camel@perches.com>
From: Kevin Cernekee <cernekee@gmail.com>
Date: Wed, 17 Dec 2014 07:53:27 -0800
Message-ID: <CAJiQ=7AxGdByudruUQtHMq-SNfmumPXP7EDzo-o2QyXWrMxv6A@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: enable MAINTAINERS warning only for --strict,--subjective
To: Joe Perches <joe@perches.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Andy Whitcroft <apw@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 1:27 AM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2014-12-16 at 23:35 -0800, Brian Norris wrote:
>> The rule which delivers this warning is very prone to errors:
>>   "added, moved or deleted file(s), does MAINTAINERS need updating?"
>> so it should not be enabled by default.
>
> I don't think so.
>
> It's _far_ more common for people to forget to
> update MAINTAINERS so I think it's quite useful
> even if it's slightly noisy.

In a recent submission I saw a bunch of these warnings too, even
though I had already added MAINTAINERS entries.

If this is just a friendly reminder ("hey, please double-check X
before you send") rather than an indication that a suspected problem
was detected in the patch, perhaps it would be better if it lived in
Documentation/SubmitChecklist?
