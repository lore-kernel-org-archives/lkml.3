Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbaKZPjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:39:46 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:44727 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaKZPjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:39:44 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrV1vChd9m_AtFjPfddqvPK3z3cjROozWJ8HQHSGm5KWJQ@mail.gmail.com>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
 <1416546149-24799-2-git-send-email-gregkh@linuxfoundation.org>
 <CALCETrWUekPq6pquuiVperBihQHgcvCF=WzVJTZziHhUJYsh4Q@mail.gmail.com>
 <CANq1E4QA53-L8vPOWJfjhzXaYVQnNvgvR6AcYev0EaP6SfOjQQ@mail.gmail.com>
 <CALCETrUfNG=YwwM2m78Ua4fUr9daE1omQwOSJQMKC6CTCa28fQ@mail.gmail.com>
 <CANq1E4TOe5SNmAvnjs1LCx9EGrGWxqX8qPUy26n8RzGo2kvThg@mail.gmail.com> <CALCETrV1vChd9m_AtFjPfddqvPK3z3cjROozWJ8HQHSGm5KWJQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 26 Nov 2014 07:39:22 -0800
Message-ID: <CALCETrWB2ZBnqRtf=1VU9urYxgtgPYNfXy-y=BmhGXi032mhFg@mail.gmail.com>
Subject: Re: kdbus: add documentation
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Mack <daniel@zonque.org>, Djalal Harouni <tixxdz@opendz.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 7:30 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> Then find a clean way that's gated on having the right /proc access,
> which is not guaranteed to exist on all of your eventual users'
> systems, and, if that access doesn't exist because the admin or
> sandbox designer has sensibly revoked it, then kdbus shouldn't
> override them.

One idea: add a sysctl that defaults to off that enables these
metadata items, and keep it disabled on production systems.  Then you
get your debugging and everyone else gets unsurprising behavior.

--Andy

>
> --Andy



-- 
Andy Lutomirski
AMA Capital Management, LLC
