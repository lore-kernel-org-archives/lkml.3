Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbbAOW6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:58:40 -0500
Received: from ozlabs.org ([103.22.144.67]:55961 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586AbbAOW6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:58:38 -0500
Message-ID: <1421362698.23332.6.camel@ellerman.id.au>
Subject: Re: [PATCH v4 20/20] kbuild: add a new kselftest_install make
 target to install selftests
From: Michael Ellerman <mpe@ellerman.id.au>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: mmarek@suse.cz, masami.hiramatsu.pt@hitachi.com,
        gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        keescook@chromium.org, tranmanphong@gmail.com, cov@codeaurora.org,
        dh.herrmann@gmail.com, hughd@google.com, bobby.prani@gmail.com,
        serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        tim.bird@sonymobile.com, josh@joshtriplett.org, koct9i@gmail.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org
Date: Fri, 16 Jan 2015 09:58:18 +1100
In-Reply-To: <54B69A1B.80006@osg.samsung.com>
References: <cover.1420571615.git.shuahkh@osg.samsung.com>
	 <2c5a28faaa79d9c2415854a08817ada509fcb943.1420571615.git.shuahkh@osg.samsung.com>
	 <54B69A1B.80006@osg.samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-14 at 09:32 -0700, Shuah Khan wrote:
> On 01/06/2015 12:43 PM, Shuah Khan wrote:
> > Add a new make target to install to install kernel selftests.
> > This new target will build and install selftests. kselftest
> > target now depends on kselftest_install and runs the generated
> > kselftest script to reduce duplicate work and for common look
> > and feel when running tests.
> > 
> > make kselftest_target:
> > -- exports kselftest INSTALL_KSFT_PATH
> >    default $(INSTALL_MOD_PATH)/lib/kselftest/$(KERNELRELEASE)
> > -- exports INSTALL_KSFT_PATH
> > -- runs selftests make install target
> > 
> > Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> 
> Hi Marek,
> 
> Could you please Ack this patch, if this version looks good,
> so I can take this through ksefltest tree.

Hi Shuah,

I posted what I think is a better approach last week. It's less code and less
repetition, and installs the majority of tests this series missed - ie. the
powerpc ones.

Please at least respond to it before you put this series into next.

https://lkml.org/lkml/2015/1/9/45

cheers


