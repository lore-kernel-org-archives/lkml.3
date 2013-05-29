Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965366Ab3E2JS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:18:27 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:2524 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965261Ab3E2JSY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:18:24 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'johnspaul92'" <johns@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 29 May 2013 17:18:19 +0800
Subject: RE: definition of sys_access function
Thread-Topic: definition of sys_access function
Thread-Index: Ac5cRmnKiakdhtD+RLGqRp/MIfuBxgABvdfQ
Message-ID: <35FD53F367049845BC99AC72306C23D1610991B864@CNBJMBX05.corpusers.net>
References: <1369815177019-657210.post@n7.nabble.com>
 <CAFLxGvx4v3xNE_rAzRULLbmbJFpaPakCw8Ng7EJKsWLx1b+Xjw@mail.gmail.com>
 <1369816052236-657226.post@n7.nabble.com>
In-Reply-To: <1369816052236-657226.post@n7.nabble.com>
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

Hi  

You should search like this in  fs/open.c

SYSCALL_DEFINE2(access, const char __user *, filename, int, mode)

You can find it .

Thanks 

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of johnspaul92
Sent: Wednesday, May 29, 2013 4:28 PM
To: linux-kernel@vger.kernel.org
Subject: Re: definition of sys_access function

I tried that and i got the result as fs/open.c But i couldnt find any references to sys_access.




--
View this message in context: http://linux-kernel.2935.n7.nabble.com/definition-of-sys-access-function-tp657210p657226.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
