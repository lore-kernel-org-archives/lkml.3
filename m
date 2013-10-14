Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab3JNSh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 14:37:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50040 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab3JNSh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 14:37:27 -0400
Message-ID: <525C39E2.4030507@canonical.com>
Date: Mon, 14 Oct 2013 11:37:22 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: SECURITY SUBSYSTEM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: Re: apparmor: two more regression fixes for 3.12
References: <525906EE.90409@canonical.com> <alpine.LRH.2.02.1310150220160.6053@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.02.1310150220160.6053@tundra.namei.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 08:20 AM, James Morris wrote:
> On Sat, 12 Oct 2013, John Johansen wrote:
> 
>> Hi James,
>>
>>   Can you please pull and forward the following 2 fixes for regressions in
>>   3.12 apparmor
>>

sure replied below or you can pull them from the branch below which I just rebased

The following changes since commit d6099aeb4a9aad5e7ab1c72eb119ebd52dee0d52:

  Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm (2013-10-14 10:02:23 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jj/linux-apparmor for-security

for you to fetch changes up to 78aaf3232b29abbc83521814b946158b5c6293fc:

  apparmor: fix bad lock balance when introspecting policy (2013-10-14 11:31:34 -0700)

----------------------------------------------------------------
John Johansen (2):
      apparmor: fix memleak of the profile hash
      apparmor: fix bad lock balance when introspecting policy

 security/apparmor/apparmorfs.c | 4 +---
 security/apparmor/policy.c     | 1 +
 2 files changed, 2 insertions(+), 3 deletions(-)

