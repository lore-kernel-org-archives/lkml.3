Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbaLCOJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:09:41 -0500
Received: from lists.s-osg.org ([54.187.51.154]:39074 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836AbaLCOJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:09:39 -0500
Message-ID: <547F199A.3020600@osg.samsung.com>
Date: Wed, 03 Dec 2014 07:09:30 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: linux-next: manual merge of the kselftest tree with the kselftest-fixes
 tree
References: <20141203203210.2eef1e6c@canb.auug.org.au> <1417607797.23663.1.camel@concordia>
In-Reply-To: <1417607797.23663.1.camel@concordia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 04:56 AM, Michael Ellerman wrote:
> On Wed, 2014-12-03 at 20:32 +1100, Stephen Rothwell wrote:
>> Hi Shuah,
>>
>> Today's linux-next merge of the kselftest tree got a cselftests/kcmp:
>> Always try to build the testonflict in
>> tools/testing/selftests/kcmp/Makefile between commit 4c12df63f7ff ("")
>> from the kselftest-fixes tree and commit c0d8a9393efd
>> ("selftests/kcmp: add install target to enable installing test") from
>> the kselftest tree.
> 
> That got a bit mixed up, I think it should be:
> 
>   Today's linux-next merge of the kselftest tree got a conflict in
>   tools/testing/selftests/kcmp/Makefile between commit 4c12df63f7ff
>   ("selftests/kcmp: Always try to build the test") from the kselftest-fixes
>   tree and commit c0d8a9393efd ("selftests/kcmp: add install target to enable
>   installing test") from the kselftest tree.
> 
>> I fixed it up (see below - probably some more could be done) and can
>> carry the fix as necessary (no action is required).
> 
> That resolution basically negates the effect of the first patch.
> 
> Shuah, seeing these are both your trees are you happy to do the proper
> resolution?
> 

Stephen and Michael,

I will sort this out. I have some patches in next that I should have
cleaned up yesterday when I applied commit 4c12df63f7ff.

Sorry for the mix-up

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
