Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602Ab3JKQd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 12:33:27 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:53973 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385Ab3JKQd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 12:33:26 -0400
MIME-Version: 1.0
In-Reply-To: <20131011154805.GB30181@srcf.ucam.org>
References: <20131011092837.GZ3626@debian70-amd64.local.net-space.pl>
	<877gdkce6s.fsf@tw-ebiederman.twitter.com>
	<20131011110455.GA3626@debian70-amd64.local.net-space.pl>
	<20131011125206.GA2772@redhat.com>
	<20131011153727.GA30181@srcf.ucam.org>
	<20131011154450.GB2772@redhat.com>
	<20131011154805.GB30181@srcf.ucam.org>
Date: Fri, 11 Oct 2013 18:33:23 +0200
Message-ID: <CAFLxGvzf1sQy-d03JAnK7eDQdBXrd-zRjcKEbv_x53st5bYELg@mail.gmail.com>
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

On Fri, Oct 11, 2013 at 5:48 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Fri, Oct 11, 2013 at 11:44:50AM -0400, Vivek Goyal wrote:
>
>> Just Curious. How is it useful. IOW, what's your use case of booting a new
>> kernel and then jumping back.
>
> I'm kexecing into a kernel with a modified /dev/mem, modifying the
> original kernel and then jumping back into it.

How do you update the original kernel?
Sounds interesting.

-- 
Thanks,
//richard
