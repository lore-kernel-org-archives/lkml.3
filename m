Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3JCUtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:49:33 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:54431 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab3JCUtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:49:06 -0400
From: Paul Moore <paul@paul-moore.com>
To: Dave Jones <davej@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
        Linux Kernel <linux-kernel@vger.kernel.org>, eparis@redhat.com,
        james.l.morris@oracle.com, selinux@tycho.nsa.gov
Subject: Re: [PATCH] conditionally reschedule while loading selinux policy.
Date: Thu, 03 Oct 2013 16:49:02 -0400
Message-ID: <1872708.6lkHAuRzGL@sifl>
User-Agent: KMail/4.11.1 (Linux/3.10.13-gentoo; KDE/4.11.1; x86_64; ; )
In-Reply-To: <20131003204031.GA25515@redhat.com>
References: <20130916173036.GA17950@redhat.com> <2297933.rECKfqAcWT@sifl> <20131003204031.GA25515@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 03, 2013 04:40:31 PM Dave Jones wrote:
> I couldn't get a backtrace when I downgraded, and reupgraded my policy,
> but that said, I didn't when I tested that way on my first patch either.
> It wasn't until I got a newer policy that I saw the 2nd spew.
> I was planning on sitting on this until the next policy update just
> to confirm.

Okay, no problem.  Let me know how it goes.

Thanks,
-Paul

-- 
paul moore
www.paul-moore.com

