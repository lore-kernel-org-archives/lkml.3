Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbaHUNXC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:23:02 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65276 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754797AbaHUNXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:23:00 -0400
Message-ID: <53F5F2AD.5010607@nod.at>
Date: Thu, 21 Aug 2014 15:22:53 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>
Subject: Re: [GIT PULL] namespace updates for v3.17-rc1
References: <87fvhav3ic.fsf@x220.int.ebiederm.org> <CAFLxGvwi-iJRyfwv8v9fcRkiSu2d-az8W55xMPbp_d8wQKmwjg@mail.gmail.com> <87vbpm4f4y.fsf@x220.int.ebiederm.org> <20140821131257.GA4264@infradead.org>
In-Reply-To: <20140821131257.GA4264@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 21.08.2014 15:12, schrieb Christoph Hellwig:
> On Wed, Aug 20, 2014 at 09:53:49PM -0700, Eric W. Biederman wrote:
>> Richard Weinberger <richard.weinberger@gmail.com> writes:
>>
>>> On Wed, Aug 6, 2014 at 2:57 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>
>>> This commit breaks libvirt-lxc.
>>> libvirt does in lxcContainerMountBasicFS():
>>
>> The bugs fixed are security issues, so if we have to break a small
>> number of userspace applications we will.  Anything that we can
>> reasonably do to avoid regressions will be done.
> 
> Can you explain the security issues in detail?  Breaking common
> userspace like libvirt-lxc with just a little bit of handwaiving is
> entirely unacceptable.

It looks like commit 87b47932f40a11280584bce260cbdb3b5f9e8b7d in
git.kernel.org/cgit/linux/kernel/git/ebiederm/user-namespace.git for-next
unbreaks libvirt-lxc.
I hope it hits Linus tree and -stable before the offending commit hits users.

Thanks,
//richard
