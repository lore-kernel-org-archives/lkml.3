Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbaKDN5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:57:34 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:57657 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaKDN5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:57:30 -0500
Date: Tue, 4 Nov 2014 08:57:26 -0500
From: Tejun Heo <tj@kernel.org>
To: Aditya Kali <adityakali@google.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Li Zefan <lizefan@huawei.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Rohit Jnagal <jnagal@google.com>
Subject: Re: [PATCHv2 7/7] cgroup: mount cgroupns-root when inside non-init
 cgroupns
Message-ID: <20141104135726.GB14014@htj.dyndns.org>
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
 <1414783141-6947-8-git-send-email-adityakali@google.com>
 <CALCETrXTaZ3SJ_t-gnbc93BVZXg-912NqO78kFd0Tpi-5-dZoQ@mail.gmail.com>
 <CAGr1F2FuPQxLraYv7PstJ9c8H-XQsgawaAtj4AS77B+_0k2o+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGr1F2FuPQxLraYv7PstJ9c8H-XQsgawaAtj4AS77B+_0k2o+A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Aditya.

On Mon, Nov 03, 2014 at 03:12:28PM -0800, Aditya Kali wrote:
> I think the sane-behavior flag is only temporary and will be removed
> anyways, right? So I didn't bother asking user to supply it. But I can
> make the change as you suggested. We just have to make sure that tasks
> inside cgroupns cannot mount non-default hierarchies as it would be a
> regression.

I'm not sure whether supporting mounting from inside a ns is even
necessary but, if it is, can't you just test against cgrp_dfl_root?
There's no reason to do anything differnetly for ns mounting.

Thanks.

-- 
tejun
