Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbaIPRrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 13:47:46 -0400
Received: from lists.s-osg.org ([54.187.51.154]:36316 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096AbaIPRrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 13:47:45 -0400
Message-ID: <541877BE.5080903@osg.samsung.com>
Date: Tue, 16 Sep 2014 11:47:42 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Davidlohr Bueso <dave@stgolabs.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, colin.king@canonical.com,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, thierry@linux.vnet.ibm.com,
        felipensp@gmail.com, Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 1/7] selftests: add header file for test exit code defines
References: <1410820442-8774-1-git-send-email-shuahkh@osg.samsung.com> <1410820442-8774-2-git-send-email-shuahkh@osg.samsung.com> <1410883441.4630.9.camel@linux-t7sj.site> <54187400.10506@osg.samsung.com> <CALCETrUw21Bgd9N4wakP08OiFshxzPS6wBE6=Fd2K=k33RDgXA@mail.gmail.com>
In-Reply-To: <CALCETrUw21Bgd9N4wakP08OiFshxzPS6wBE6=Fd2K=k33RDgXA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2014 11:40 AM, Andy Lutomirski wrote:
> On Tue, Sep 16, 2014 at 10:31 AM, Shuah Khan <shuahkh@osg.samsung.com> wrote:

> 
> I think we will want a framework in the tree, but it can be very
> minimal.  But I also think that using exit(2) for this is wrong.  Why
> not:
> 
> enum ktest_result {
>   KTEST_PASS,
>   ...,
> };
> 
> void ktest_exit(enum ktest_result result);
> 
> With the possibility of further extensions for more than one test (and
> associated result) per execution of the test binary.
> 

Nothing wrong with the approach. It is one of the options I considered
and decided against it primarily because tests need more changes than
the ones needed for return codes. However, maybe it is worth while to
do so. I will play with this and see how extensive the changes are.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
