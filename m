Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbaEIJRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:17:20 -0400
Received: from mail02-md.ns.itscom.net ([175.177.155.112]:58286 "EHLO
	mail02-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaEIJRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:17:18 -0400
From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: IMA + O_DIRECT (Re: [PATCH 0/1] fix IMA + Apparmor kernel panic)
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: viro@zeniv.linux.org.uk, ebiederm@xmission.com,
        linux-security-module@vger.kernel.org, eparis@redhat.com,
        zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <536C8E64.6000009@samsung.com>
References: <cover.1399554584.git.d.kasatkin@samsung.com> <29977.1399605003@jrobl> <536C8E64.6000009@samsung.com>
Date: Fri, 09 May 2014 18:17:01 +0900
Message-ID: <11673.1399627021@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dmitry Kasatkin:
> It is a different issue.
>
> I made patch more than a year ago which fix the problem
>
> https://lkml.org/lkml/2013/2/20/601

Yes, I know this is a different issue, but I didn't know the patch.
While I am not sure how ugly (or beautiful) is the approache the patch
took, as long as IMA needs to read the file, we should merge the merge.
Or we should wait for your another patch.


J. R. Okajima
