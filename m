Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab3JKQrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 12:47:32 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755324Ab3JKQra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 12:47:30 -0400
Message-ID: <52582B97.2060907@nod.at>
Date: Fri, 11 Oct 2013 18:47:19 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Richard Weinberger <richard.weinberger@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, hbabu@us.ibm.com,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, kexec@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, david.vrabel@citrix.com,
        jbeulich@suse.com, keir@xen.org, xen-devel@lists.xen.org
Subject: Re: kexec: Clearing registers just before jumping into purgatory
References: <20131011092837.GZ3626@debian70-amd64.local.net-space.pl> <877gdkce6s.fsf@tw-ebiederman.twitter.com> <20131011110455.GA3626@debian70-amd64.local.net-space.pl> <20131011125206.GA2772@redhat.com> <20131011153727.GA30181@srcf.ucam.org> <20131011154450.GB2772@redhat.com> <20131011154805.GB30181@srcf.ucam.org> <CAFLxGvzf1sQy-d03JAnK7eDQdBXrd-zRjcKEbv_x53st5bYELg@mail.gmail.com> <20131011163933.GA31941@srcf.ucam.org> <CAFLxGvyDYHy-UbZhdQiGvXL=8t0aW8wABc0GRkwVRy8egKJMKw@mail.gmail.com> <20131011164400.GA32133@srcf.ucam.org>
In-Reply-To: <20131011164400.GA32133@srcf.ucam.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 11.10.2013 18:44, schrieb Matthew Garrett:
> On Fri, Oct 11, 2013 at 06:42:36PM +0200, Richard Weinberger wrote:
>> On Fri, Oct 11, 2013 at 6:39 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>>> On Fri, Oct 11, 2013 at 06:33:23PM +0200, Richard Weinberger wrote:
>>>> On Fri, Oct 11, 2013 at 5:48 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>>>>> On Fri, Oct 11, 2013 at 11:44:50AM -0400, Vivek Goyal wrote:
>>>>>
>>>>>> Just Curious. How is it useful. IOW, what's your use case of booting a new
>>>>>> kernel and then jumping back.
>>>>>
>>>>> I'm kexecing into a kernel with a modified /dev/mem, modifying the
>>>>> original kernel and then jumping back into it.
>>>>
>>>> How do you update the original kernel?
>>>
>>> It's still in RAM, so the same way you'd modify any other arbitrary
>>> physical address?
>>
>> So, you have a tool like ksplice which patches the kernel in RAM?
> 
> I have /dev/mem and a list of addresses I want to modify.

But you still need a magic tool which create you this list.
If you have a tool which takes two kernel images and create such
a delta, fine.
I'm interested in that tool. :-)

Thanks,
//richard

