Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbaIWXHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 19:07:52 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:35038 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbaIWXHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 19:07:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        colin.king@canonical.com, dbueso@suse.de, serge.hallyn@ubuntu.com,
        thierry@linux.vnet.ibm.com, luto@amacapital.net,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1411506121.git.shuahkh@osg.samsung.com>
	<cover.1411506121.git.shuahkh@osg.samsung.com>
	<969f0780734a04763f2b54063603b93380244d0c.1411506121.git.shuahkh@osg.samsung.com>
	<87d2am2c4v.fsf@x220.int.ebiederm.org>
	<5421FA8A.9050209@osg.samsung.com>
Date: Tue, 23 Sep 2014 16:07:28 -0700
In-Reply-To: <5421FA8A.9050209@osg.samsung.com> (Shuah Khan's message of "Tue,
	23 Sep 2014 16:56:10 -0600")
Message-ID: <8761geylzj.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19ugW+pHBbbVNbbgkIkjN43AIitWWWt3qs=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.4 XM_Superlative01 Best-rated language
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4796]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Shuah Khan <shuahkh@osg.samsung.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2 5/7] selftests/mount: change test to use ksft framework
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shuah Khan <shuahkh@osg.samsung.com> writes:

> On 09/23/2014 04:41 PM, Eric W. Biederman wrote:
>> Shuah Khan <shuahkh@osg.samsung.com> writes:
>> 
>>> Change mount test to use kselftest framework to report
>>> test results.
>> 
>> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> 
>> I am curious did you even run these tests?   I can't possibly see how
>> the tests would have passed with this change.  At the very least you
>> have taken this test from linear to exponential time complexity.
>> 
>
> Oops. I meant to drop this commit from the series. Sorry for the
> noise.

No problem.  Except for the unnecessary semantic change the rest of the
change looked fine.  I just wanted to make certain you didn't break my
test by accident.

Eric
