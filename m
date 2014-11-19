Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbaKSQNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:13:48 -0500
Received: from lists.s-osg.org ([54.187.51.154]:49022 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554AbaKSQNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:13:46 -0500
Message-ID: <546CC1B7.70600@osg.samsung.com>
Date: Wed, 19 Nov 2014 09:13:43 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, "David S. Miller" <davem@davemloft.net>,
        Phong Tran <tranmanphong@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Hugh Dickins <hughd@google.com>, pranith kumar <bobby.prani@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 07/19] selftests/firmware: add install target to enable
 installing test
References: <cover.1415735831.git.shuahkh@osg.samsung.com> <1d2d13556ddbbbbb13989cdcb08447909bc4afaf.1415735831.git.shuahkh@osg.samsung.com> <CAGXu5j+yLqH0xj=5N90LRmK9F1xPLVWBy+cyUCzjvKJH7gE7AA@mail.gmail.com> <5462B2A3.9000007@osg.samsung.com>
In-Reply-To: <5462B2A3.9000007@osg.samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2014 06:06 PM, Shuah Khan wrote:
> On 11/11/2014 02:29 PM, Kees Cook wrote:
>> Hi,
>>
>> Sorry, I still really don't like this approach. While it is all in one
>> place (thank you for that), I think it isn't a form that is very
>> workable for the people maintaining the self tests. How about this,
>> instead of per-Makefile customization, why not define an execution
>> framework for these tests instead.
> 
> If I understand correctly, sounds like you don't like the way
> install target is implemented in the individual test Makefiles
> and the changes I made to run_tests targets to address the code
> duplication concern.
> 
> At the moment there is no duplicate code in this patch series
> between install and run_tests targets. This is a  first step
> towards standardizing the framework and a definite improvement
> over what we have currently. As I mentioned earlier, my goal
> is to make it easier for developers to install and run the
> existing tests and evolve the framework as we go.
> 
> Assuming my understanding is correct that:
> 
> -- install and run_tests targets in individual tests can be
>    refined and automated with a common Makefile approach you
>    proposed.
> -- the rest of the user-interface kselftest_install and kselftest
>    are good.
> 
> I would like to propose that we get started with the current
> implementation and refine it based on the following ideas you
> suggested. The refinements you are recommending are confined
> to selftests and can be made after the kselftest_install
> gets added. Adding kselftest_install makes it easier to make
> the refinements as it defines overall UI.
> 

Hi Kees,

Are you ok with the above proposal? I understand this approach
might not be perfect, however it is a step in the right direction
to enable and make it easier to run them. I would like to get some
initial work in for 3.19 if at all possible.

I plan to evolve the back-end to make it easier to write and
maintain for developers writing tests going forward.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
