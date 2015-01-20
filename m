Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbbATDNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:13:22 -0500
Received: from ozlabs.org ([103.22.144.67]:46254 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbbATDNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:13:19 -0500
Message-ID: <1421723595.10632.2.camel@ellerman.id.au>
Subject: Re: [PATCH 2/6] selftests: Add install target
From: Michael Ellerman <mpe@ellerman.id.au>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, mmarek@suse.cz, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, keescook@chromium.org, tranmanphong@gmail.com,
        cov@codeaurora.org, dh.herrmann@gmail.com, hughd@google.com,
        bobby.prani@gmail.com, serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        tim.bird@sonymobile.com, josh@joshtriplett.org, koct9i@gmail.com,
        linux-kbuild@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org
Date: Tue, 20 Jan 2015 14:13:15 +1100
In-Reply-To: <54BD326A.6030409@osg.samsung.com>
References: <1420794375-31881-1-git-send-email-mpe@ellerman.id.au>
	 <1420794375-31881-2-git-send-email-mpe@ellerman.id.au>
	 <54B94E75.8030504@osg.samsung.com> <1421627752.3787.8.camel@ellerman.id.au>
	 <54BD326A.6030409@osg.samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-19 at 09:35 -0700, Shuah Khan wrote:
> On 01/18/2015 05:35 PM, Michael Ellerman wrote:
> > On Fri, 2015-01-16 at 10:46 -0700, Shuah Khan wrote:
> >> On 01/09/2015 02:06 AM, Michael Ellerman wrote:
> >>> This adds make install support to selftests. The basic usage is:
> >>>
> >>> $ cd tools/testing/selftests
> >>> $ make install
> >>>
> >>> That installs into tools/testing/selftests/install, which can then be
> >>> copied where ever necessary.
> >>>
> >>> The install destination is also configurable using eg:
> >>>
> >>> $ INSTALL_PATH=/mnt/selftests make install
> >>
> >> Please see my response to [PATCH 4/6] kbuild: add a new
> >> kselftest_install make target to install selftests
> >>
> >> These are addressed by the current approach to use existing
> >> INSTALL_MOD_PATH.
> > 
> > No that's a separate issue.
> > 
> > This patch adds install support for tools/testing/selftests, *completely
> > separate* from the kbuild infrastructure. 
> 
> What's the use-case for this feature? I don't see why we need multiple
> ways to do the install?

Exactly the use case I described in the sentence above.

Currently the selftests directory is usable on its own. You can copy the
selftests directory somewhere and it is functional. That is a useful feature,
and there's no reason to break it.

cheers


