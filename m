Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbaEJRa4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 13:30:56 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:50491 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaEJRay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 13:30:54 -0400
MIME-Version: 1.0
In-Reply-To: <22172.1399666028@jrobl>
References: <cover.1399554584.git.d.kasatkin@samsung.com>
	<29977.1399605003@jrobl>
	<536C8E64.6000009@samsung.com>
	<11673.1399627021@jrobl>
	<1399647534.2232.8.camel@dhcp-9-2-203-236.watson.ibm.com>
	<18674.1399651287@jrobl>
	<1399664699.2232.59.camel@dhcp-9-2-203-236.watson.ibm.com>
	<22172.1399666028@jrobl>
Date: Sat, 10 May 2014 20:30:53 +0300
Message-ID: <CACE9dm_ARNNjCd=sM7VJ1k1H_cMYrPXd6mwttEOsMjeUb2c8mg@mail.gmail.com>
Subject: Re: IMA + O_DIRECT (Re: [PATCH 0/1] fix IMA + Apparmor kernel panic)
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: "J. R. Okajima" <hooanon05g@gmail.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        eparis@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 May 2014 23:07, J. R. Okajima <hooanon05g@gmail.com> wrote:
>
> Mimi Zohar:
>> I assume so, as there wasn't any comment.  As a temporary fix, would it
>> make sense not to measure/appraise/audit files opened with the direct-io
>> flag based policy?  Define a new IMA policy option 'directio'.  A sample
>> rule would look like:
>>
>> dont_appraise bprm_check directio fsuuid=...
>
> I prefer such approach or anything addressing in IMA only, so it makes
> sense.
>
>
> J. R. Okajima


We are working on i_mutex free solution.
Let's hold on on this...

-- 
Thanks,
Dmitry
