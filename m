Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab3GAL5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 07:57:51 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46405 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab3GAL5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 07:57:50 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130701115858.634b5041f65ca32effec0570@canb.auug.org.au>
References: <20130701010321.GA6763@phenom.dumpdata.com> <20130701115858.634b5041f65ca32effec0570@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [GIT PULL] (xen) stable/for-linus-3.11-rc0-tag
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 01 Jul 2013 07:57:36 -0400
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Message-ID: <575e3d4c-9ea9-45a5-ab8c-3dd30c833ad7@email.android.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

>Hi Konrad,
>
>On Sun, 30 Jun 2013 21:03:21 -0400 Konrad Rzeszutek Wilk
><konrad.wilk@oracle.com> wrote:
>>
>> Since the merge window opened merely three hours ago and I am sure
>> you are addictively refreshing your email for the next set of
>> GIT PULLs and can't wait for them - I figured I would offer you a
>> nice little evening GIT-PULL snack to sustain you until Monday
>> GIT-PULL-email-avalanche :-)
>> 
>> With that in mind please git pull the following tag:
>> 
>>  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git 
>stable/for-linus-3.11-rc0-tag
>
>Not sure why you did a back merge of Linus' tree right at the end
>there?

No idea either.  It should have been a tag on top of stable/for-linus-3.11.' but it ended up on the test branch. I will recreate it on top of the_right_ branch and send a other Git pull.  Thanks for noticing! 
-- 
Sent from my Android phone. Please excuse my brevity.
