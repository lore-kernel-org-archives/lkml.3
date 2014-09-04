Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbaIDPRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:17:03 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:56812 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaIDPRB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:17:01 -0400
MIME-Version: 1.0
In-Reply-To: <1409843242-6596-1-git-send-email-shuahkh@osg.samsung.com>
References: <1409843242-6596-1-git-send-email-shuahkh@osg.samsung.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Thu, 4 Sep 2014 11:16:29 -0400
Message-ID: <CAJhHMCCuyC3HUfUktTpkQcxnqJDpA2O0Gqc8wZMq0TwB5PeY6w@mail.gmail.com>
Subject: Re: [PATCH] selftests/memfd: fix mfd_fail_open() to pass in buf to printf
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: David Herrmann <dh.herrmann@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        "open list:KERNEL SELFTEST F..." <linux-api@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 11:07 AM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
> mfd_fail_open() doesn't pass in the buffer to printf resulting
> in the following warning:
>
> memfd_test.c: In function ‘mfd_fail_open’:
> memfd_test.c:208:3: warning: format ‘%s’ expects a matching ‘char *’ argument [-Wformat=]
>    printf("open(%s) didn't fail as expected\n");
>    ^
>
> This change fixes the problem.
>
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>

Hi Shuah,

I already sent in a patch to fix this:

https://lkml.org/lkml/2014/8/31/85

Can you please pick that up?

Thanks!
-- 
Pranith
