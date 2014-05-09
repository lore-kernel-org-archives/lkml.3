Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbaEIO7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 10:59:49 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:55128 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaEIO7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 10:59:47 -0400
Message-ID: <1399647534.2232.8.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: IMA + O_DIRECT (Re: [PATCH 0/1] fix IMA + Apparmor kernel panic)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "J. R. Okajima" <hooanon05g@gmail.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>, viro@zeniv.linux.org.uk,
        ebiederm@xmission.com, linux-security-module@vger.kernel.org,
        eparis@redhat.com, dmitry.kasatkin@gmail.com,
        linux-kernel@vger.kernel.org
Date: Fri, 09 May 2014 10:58:54 -0400
In-Reply-To: <11673.1399627021@jrobl>
References: <cover.1399554584.git.d.kasatkin@samsung.com>
	 <29977.1399605003@jrobl> <536C8E64.6000009@samsung.com>
	 <11673.1399627021@jrobl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050914-9332-0000-0000-000000BD525E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-09 at 18:17 +0900, J. R. Okajima wrote: 
> Dmitry Kasatkin:
> > It is a different issue.
> >
> > I made patch more than a year ago which fix the problem
> >
> > https://lkml.org/lkml/2013/2/20/601
> 
> Yes, I know this is a different issue, but I didn't know the patch.
> While I am not sure how ugly (or beautiful) is the approache the patch
> took, as long as IMA needs to read the file, we should merge the merge.
> Or we should wait for your another patch.

Another approach was posted here
http://marc.info/?l=linux-security-module&m=138919062430367&w=2 which
also was not upstreamed.

Mimi

