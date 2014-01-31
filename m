Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771AbaAaRZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:25:57 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:61163 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaAaRZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:25:51 -0500
MIME-Version: 1.0
In-Reply-To: <CAJZ5v0gJX+AdScYjmZKCdHM=pGUX=2jymvDvUGqQ8OU8MNNb-w@mail.gmail.com>
References: <CAJZ5v0gJX+AdScYjmZKCdHM=pGUX=2jymvDvUGqQ8OU8MNNb-w@mail.gmail.com>
Date: Fri, 31 Jan 2014 09:25:49 -0800
X-Google-Sender-Auth: BlzV3tmh8JeFHPxkucIJs9mXqbk
Message-ID: <CA+55aFzzTo+sE9pX9tmK61ctEFBUdYm5YQuuCndrMoeLC_RhRA@mail.gmail.com>
Subject: Re: [GIT PULL][Resend] ACPI and power management fixes and cleanup
 for v3.14-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rafael Wysocki <rjwysocki@gmail.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 3:21 AM, Rafael Wysocki <rjwysocki@gmail.com> wrote:
>
> It looks like gmail doesn't want you to receive any messages from
> rjwysocki.net, regardless of the signature, so here it goes again from my
> gmail account.

Actually, I got the previous one from rjwysocki.net, it just got
delayed by me doing mostly fs and architecture merges yesterday.

Pulled now, going through test-compiles before pushing out

              Linus
