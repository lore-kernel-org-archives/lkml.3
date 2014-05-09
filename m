Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbaEIUHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 16:07:14 -0400
Received: from mail03-md.ns.itscom.net ([175.177.155.113]:44953 "EHLO
	mail03-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757165AbaEIUHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 16:07:11 -0400
From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: IMA + O_DIRECT (Re: [PATCH 0/1] fix IMA + Apparmor kernel panic)
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>, viro@zeniv.linux.org.uk,
        ebiederm@xmission.com, linux-security-module@vger.kernel.org,
        eparis@redhat.com, dmitry.kasatkin@gmail.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1399664699.2232.59.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <cover.1399554584.git.d.kasatkin@samsung.com> <29977.1399605003@jrobl> <536C8E64.6000009@samsung.com> <11673.1399627021@jrobl> <1399647534.2232.8.camel@dhcp-9-2-203-236.watson.ibm.com> <18674.1399651287@jrobl> <1399664699.2232.59.camel@dhcp-9-2-203-236.watson.ibm.com>
Date: Sat, 10 May 2014 05:07:08 +0900
Message-ID: <22172.1399666028@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mimi Zohar:
> I assume so, as there wasn't any comment.  As a temporary fix, would it
> make sense not to measure/appraise/audit files opened with the direct-io
> flag based policy?  Define a new IMA policy option 'directio'.  A sample
> rule would look like:  
>
> dont_appraise bprm_check directio fsuuid=... 

I prefer such approach or anything addressing in IMA only, so it makes
sense.


J. R. Okajima
