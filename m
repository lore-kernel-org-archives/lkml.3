Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbaIWW4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 18:56:14 -0400
Received: from lists.s-osg.org ([54.187.51.154]:37308 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160AbaIWW4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 18:56:13 -0400
Message-ID: <5421FA8A.9050209@osg.samsung.com>
Date: Tue, 23 Sep 2014 16:56:10 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        colin.king@canonical.com, dbueso@suse.de, serge.hallyn@ubuntu.com,
        thierry@linux.vnet.ibm.com, luto@amacapital.net,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH v2 5/7] selftests/mount: change test to use ksft framework
References: <cover.1411506121.git.shuahkh@osg.samsung.com> <cover.1411506121.git.shuahkh@osg.samsung.com> <969f0780734a04763f2b54063603b93380244d0c.1411506121.git.shuahkh@osg.samsung.com> <87d2am2c4v.fsf@x220.int.ebiederm.org>
In-Reply-To: <87d2am2c4v.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2014 04:41 PM, Eric W. Biederman wrote:
> Shuah Khan <shuahkh@osg.samsung.com> writes:
> 
>> Change mount test to use kselftest framework to report
>> test results.
> 
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> I am curious did you even run these tests?   I can't possibly see how
> the tests would have passed with this change.  At the very least you
> have taken this test from linear to exponential time complexity.
> 

Oops. I meant to drop this commit from the series. Sorry for the noise.

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
