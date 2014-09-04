Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbaIDPVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:21:37 -0400
Received: from lists.s-osg.org ([54.187.51.154]:52888 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbaIDPVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:21:35 -0400
Message-ID: <5408837B.6040008@osg.samsung.com>
Date: Thu, 04 Sep 2014 09:21:31 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Pranith Kumar <bobby.prani@gmail.com>
CC: David Herrmann <dh.herrmann@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        "open list:KERNEL SELFTEST F..." <linux-api@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] selftests/memfd: fix mfd_fail_open() to pass in buf to
 printf
References: <1409843242-6596-1-git-send-email-shuahkh@osg.samsung.com> <CAJhHMCCuyC3HUfUktTpkQcxnqJDpA2O0Gqc8wZMq0TwB5PeY6w@mail.gmail.com>
In-Reply-To: <CAJhHMCCuyC3HUfUktTpkQcxnqJDpA2O0Gqc8wZMq0TwB5PeY6w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 09:16 AM, Pranith Kumar wrote:
> On Thu, Sep 4, 2014 at 11:07 AM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
>> mfd_fail_open() doesn't pass in the buffer to printf resulting
>> in the following warning:
>>
>> memfd_test.c: In function ‘mfd_fail_open’:
>> memfd_test.c:208:3: warning: format ‘%s’ expects a matching ‘char *’ argument [-Wformat=]
>>    printf("open(%s) didn't fail as expected\n");
>>    ^
>>
>> This change fixes the problem.
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> 
> Hi Shuah,
> 
> I already sent in a patch to fix this:
> 
> https://lkml.org/lkml/2014/8/31/85
> 
> Can you please pick that up?

Hi Pranith,

Great. Could you please resend it to me cc'ing linux-api as well.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
