Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab3JKQmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 12:42:38 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:56179 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab3JKQmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 12:42:37 -0400
MIME-Version: 1.0
In-Reply-To: <20131011163933.GA31941@srcf.ucam.org>
References: <20131011092837.GZ3626@debian70-amd64.local.net-space.pl>
	<877gdkce6s.fsf@tw-ebiederman.twitter.com>
	<20131011110455.GA3626@debian70-amd64.local.net-space.pl>
	<20131011125206.GA2772@redhat.com>
	<20131011153727.GA30181@srcf.ucam.org>
	<20131011154450.GB2772@redhat.com>
	<20131011154805.GB30181@srcf.ucam.org>
	<CAFLxGvzf1sQy-d03JAnK7eDQdBXrd-zRjcKEbv_x53st5bYELg@mail.gmail.com>
	<20131011163933.GA31941@srcf.ucam.org>
Date: Fri, 11 Oct 2013 18:42:36 +0200
Message-ID: <CAFLxGvyDYHy-UbZhdQiGvXL=8t0aW8wABc0GRkwVRy8egKJMKw@mail.gmail.com>
Subject: Re: kexec: Clearing registers just before jumping into purgatory
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, Daniel Kiper <daniel.kiper@oracle.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, hbabu@us.ibm.com,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, kexec@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, david.vrabel@citrix.com,
        jbeulich@suse.com, keir@xen.org, xen-devel@lists.xen.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 6:39 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Fri, Oct 11, 2013 at 06:33:23PM +0200, Richard Weinberger wrote:
>> On Fri, Oct 11, 2013 at 5:48 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> > On Fri, Oct 11, 2013 at 11:44:50AM -0400, Vivek Goyal wrote:
>> >
>> >> Just Curious. How is it useful. IOW, what's your use case of booting a new
>> >> kernel and then jumping back.
>> >
>> > I'm kexecing into a kernel with a modified /dev/mem, modifying the
>> > original kernel and then jumping back into it.
>>
>> How do you update the original kernel?
>
> It's still in RAM, so the same way you'd modify any other arbitrary
> physical address?

So, you have a tool like ksplice which patches the kernel in RAM?

-- 
Thanks,
//richard
