Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab3FGRz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 13:55:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60450 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171Ab3FGRzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 13:55:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Tang <dt.tangr@gmail.com>
Subject: Re: [PATCH] Add Initial TI-Nspire support
Date: Fri, 7 Jun 2013 19:55:26 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
References: <E775DD08-5516-468E-9924-0D839218D7F9@gmail.com> <D6B73C11-1EB8-472B-BA1E-E48CF205B43F@gmail.com>
In-Reply-To: <D6B73C11-1EB8-472B-BA1E-E48CF205B43F@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306071955.26375.arnd@arndb.de>
X-Provags-ID: V02:K0:VhVuVppR/0GhPCZTx080/nU9pyNmrVW7VNxrHbyyWCw
 ymE7/pBZYPWx51i3JAS26u/l8EWWsSZzOV6XLPgYB0hJl5jP0X
 OCY1xsa6h5Qem9ZCoVu6R8nL+i/2wqyZJo3IT+4xAWxdD6OaiB
 um0/ZsdD03gYKVqq49EmeeIR3CmxAE48r+fJrPAS+kgCn0RW+C
 A+je8ahmR5MK7ewX7nYRxhVQiUuxM0laXHQFNp7Mp3QVYP/hjy
 Yowp6bp+EHJ9tKNK1UntH+TVOyPhvziCJNlG0wctpMZzvegxE1
 MtGOf8BVyDaXqv3MDSyXfFCBeVezRkDUFngfCkkZNtZ1ZWLDNE
 0I9q4gJV2+bmSfHawJfk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 June 2013, Daniel Tang wrote:
> Hi,
> 
> I was wondering if this patch had gone through yet.

Sorry, not yet. Olof and I are usually taking turns with merging things
into the arm-soc tree, but in the past few weeks he has done all of it,
and he was not on Cc the patch. Please make sure you always send submissions
for inclusion (as opposed to submissions for review purposes) to
arm@kernel.org so it reaches both of us.

We are also sometimes missing requests for merging for patches (rather
than git pull requests), so if you don't see your code show up in
linux-next when it should, just send a friendly reminder like
this one. I don't currently have a good overview of what pull
requests are missing, so I think Olof should apply this one, or
we can do a handover next week so I do the merging again for some
time.

	Arnd
