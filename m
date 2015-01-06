Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbbAFAR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 19:17:29 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777AbbAFAR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 19:17:26 -0500
Message-ID: <54AB2992.6060707@nod.at>
Date: Tue, 06 Jan 2015 01:17:22 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Aditya Kali <adityakali@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Rohit Jnagal <jnagal@google.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
References: <1417744550-6461-1-git-send-email-adityakali@google.com> <1417744550-6461-9-git-send-email-adityakali@google.com> <548E17CE.8010704@nod.at> <CAGr1F2HA6mzFwgp5ngX8P7=198-5CmCjLmuCJ8j3eQ08J2d9Qw@mail.gmail.com> <54AB15BD.8020007@nod.at> <87lhlgpyxk.fsf@x220.int.ebiederm.org> <CAGr1F2HSi_D07r2c5CKOsjSR1+58k9G2MrtACsd+HV6XKvJ7cA@mail.gmail.com>
In-Reply-To: <CAGr1F2HSi_D07r2c5CKOsjSR1+58k9G2MrtACsd+HV6XKvJ7cA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.01.2015 um 01:10 schrieb Aditya Kali:
> Since the old/default behavior is on its way out, I didn't invest time
> in fixing that. Also, some of the properties that make
> cgroup-namespace simpler are only provided by unified hierarchy (for
> example: a single root-cgroup per container).

Does the new sane cgroupfs behavior even have a single real world user?
I always thought it isn't stable yet.

Linux distros currently use systemd v210. They don't dare to use a newer one.
Even *if* systemd would support the sane sane cgroupfs behavior in the most recent
version it will take 1-2 years until it would hit a recent distro.

So please support also the old and nasty behavior such that one day we can run current
systemd distros in Linux containers.

Thanks,
//richard
