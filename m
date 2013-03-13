Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab3CMLrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:47:10 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:48982 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab3CMLrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:47:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130307062626.GA25095@redhat.com>
References: <20130307052854.GA23745@redhat.com>
	<20130307060230.GA31738@kroah.com>
	<20130307062626.GA25095@redhat.com>
Date: Wed, 13 Mar 2013 19:47:06 +0800
Message-ID: <CACVXFVOu-Q3ONwwYMTWoDD6hzbSsh7KwAaPzPAHeoh3aTMFafw@mail.gmail.com>
Subject: Re: use after free in sysfs_find_dirent
From: Ming Lei <tom.leiming@gmail.com>
To: Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 2:26 PM, Dave Jones <davej@redhat.com> wrote:
> Could be some of those that caused these bugs.
>
> I just retried rerunning the test a few times.  Every time I run for a while
> I end up with different crashes.  It's raining bugs over here.
> (Here's another sysfs one below)
>
> Running 'trinity -c mkdirat -V /sys' doesn't seem to trigger it, so it's an
> interaction with something else maybe.

Maybe it is helpful for trinity to output some previous recorded operations
on /sysfs when the crash is triggered.

Thanks,
-- 
Ming Lei
