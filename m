Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965192Ab3E2I2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 04:28:34 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:19803 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965032Ab3E2I2c convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 04:28:32 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'richard -rw- weinberger'" <richard.weinberger@gmail.com>,
        johnspaul92 <johns@ti.com>
CC: LKML <linux-kernel@vger.kernel.org>
Date: Wed, 29 May 2013 16:28:28 +0800
Subject: RE: definition of sys_access function
Thread-Topic: definition of sys_access function
Thread-Index: Ac5cRUEonuIU9a7ATqS8VW84VecaoAAARcaA
Message-ID: <35FD53F367049845BC99AC72306C23D1610991B85F@CNBJMBX05.corpusers.net>
References: <1369815177019-657210.post@n7.nabble.com>
 <CAFLxGvx4v3xNE_rAzRULLbmbJFpaPakCw8Ng7EJKsWLx1b+Xjw@mail.gmail.com>
In-Reply-To: <CAFLxGvx4v3xNE_rAzRULLbmbJFpaPakCw8Ng7EJKsWLx1b+Xjw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  Richard ,

This system call is defined in this file :

Kernel/fs/open.c 

Please check it .

Thanks 

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of richard -rw- weinberger
Sent: Wednesday, May 29, 2013 4:19 PM
To: johnspaul92
Cc: LKML
Subject: Re: definition of sys_access function

On Wed, May 29, 2013 at 10:12 AM, johnspaul92 <johns@ti.com> wrote:
> Where can i find the definition of the sys_access function???
> I tried checking in syscalls.h. But there i found only the declaration.
> Where can i find the definition so that i can understand what that 
> function actually does.

Use git grep to find out.
E.g. git grep "SYSCALL_DEFINE[0-9](access"

--
Thanks,
//richard
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
