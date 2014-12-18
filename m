Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaLRCpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 21:45:53 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:58319 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaLRCpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 21:45:52 -0500
MIME-Version: 1.0
In-Reply-To: <54923F1F.7040301@oracle.com>
References: <20141211145408.GB16800@redhat.com>
	<CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
	<20141212185454.GB4716@redhat.com>
	<CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
	<20141213165915.GA12756@redhat.com>
	<20141213223616.GA22559@redhat.com>
	<CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
	<20141214234654.GA396@redhat.com>
	<CA+55aFyUtZobUADgtss7e4w-yriMtz7hKVKs=Ed72KQoQ9n2nA@mail.gmail.com>
	<CA+55aFwE3gY+ChZtBpPtt_eY9nCj6pgF_wd8utRN9cOgRe2xOQ@mail.gmail.com>
	<20141215055707.GA26225@redhat.com>
	<CA+55aFyYYPgBfRdqtvqxdo==D_BOFSW3fvNULuVxPAr2vnq7Rg@mail.gmail.com>
	<CA+55aFz6KEKdz4Nxkx2fa-FH3PZ+Aa51iA_nXobsQ-dDW5PGEg@mail.gmail.com>
	<54923F1F.7040301@oracle.com>
Date: Wed, 17 Dec 2014 18:45:51 -0800
X-Google-Sender-Auth: vK4dYEUWYUslHvn8C_PN8yqCNDo
Message-ID: <CA+55aFyeNRLjNzZ8GD4bUVUZ4yUbLR56-=rYa26d_EHgy9hA7Q@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 6:42 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
> I guess you did "just screwed up"...

See the email to Dave, pick the fix from there, or from commit
cf3c0a1579ef ("x86: mm: fix VM_FAULT_RETRY handling")

                   Linus
