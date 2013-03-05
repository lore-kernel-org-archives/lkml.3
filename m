Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab3CEXgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 18:36:13 -0500
Received: from ozlabs.org ([203.10.76.45]:33473 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab3CEXgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 18:36:11 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Cc: Tommi Rantala <tt.rantala@gmail.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: cgroup_release_agent() hung task warnings
In-Reply-To: <20130304173358.GB30413@htj.dyndns.org>
References: <CA+ydwtrRAf5VW_iZYOjzmTv6Y0ebprXw_RfWVmR1okQOxQx=CA@mail.gmail.com> <51340E2E.4070805@huawei.com> <20130304173358.GB30413@htj.dyndns.org>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 05 Mar 2013 12:28:04 +1100
Message-ID: <87d2ved49n.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:
> (cc'ing Rusty Russell)
>
> On Mon, Mar 04, 2013 at 10:59:58AM +0800, Li Zefan wrote:
>> On 2013/3/3 3:23, Tommi Rantala wrote:
>> > Hello,
>> > 
>> > I'm seeing the following hung task warnings when fuzzing the kernel
>> > with trinity (in a qemu virtual machine, as the root user), that I
>> > have not seen before with 3.8 or earlier. The kernel is
>> > b0af9cd9aab60ceb17d3ebabb9fdf4ff0a99cf50 (Merge tag
>> > 'lzo-update-signature-20130226' of
>> > git://github.com/markus-oberhumer/linux).
>> > 
>> 
>> This doesn't look like a cgroup bug.
>
> Yes, it looks like a problem in usermodehelper.  Rusty, it looks like
> usermodehelper can jam with OOM killer going wild.  Any ideas?  The
> original report is at
>
>   https://lkml.org/lkml/2013/3/2/126

Is it really stuck, or just v. v. slow as it thrashes?

Like Tejun, I can't see how it would really get stuck...

Cheers,
Rusty.
