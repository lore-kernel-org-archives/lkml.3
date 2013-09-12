Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808Ab3ILDjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 23:39:39 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53710 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757630Ab3ILDjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 23:39:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <tj@kernel.org>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, kay@vrfy.org,
        netdev@vger.kernel.org, lizefan@huawei.com
References: <1378952949-7900-1-git-send-email-tj@kernel.org>
	<1378952949-7900-8-git-send-email-tj@kernel.org>
Date: Wed, 11 Sep 2013 20:39:27 -0700
In-Reply-To: <1378952949-7900-8-git-send-email-tj@kernel.org> (Tejun Heo's
	message of "Wed, 11 Sep 2013 22:29:09 -0400")
Message-ID: <87a9ji4sk0.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX181ncn4IfoJil772aBOvczujf9KTi/9Xxo=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0030]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 7/7] sysfs: @name comes before @ns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Some internal sysfs functions which take explicit namespace argument
> are weird in that they place the optional @ns in front of @name which
> is contrary to the established convention.  This is confusing and
> error-prone especially as @ns and @name may be interchanged without
> causing compilation warning.
>
> Swap the positions of @name and @ns in the following internal
> functions.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

@ns is more significant so it should come first.

Where do we have the backwards convention of putting @name first?

Eric
