Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab3AVUR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 15:17:59 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:16245 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755579Ab3AVUR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 15:17:58 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19XdRxmcR1OinlkFZeuKtA/
Date: Tue, 22 Jan 2013 12:17:53 -0800
From: Tony Lindgren <tony@atomide.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Cong Ding <dinggnu@gmail.com>, Joerg Roedel <joro@8bytes.org>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iommu: omap-iommu.c: remove unnecessary null pointer
 check
Message-ID: <20130122201752.GS22517@atomide.com>
References: <1358541741-20708-1-git-send-email-dinggnu@gmail.com>
 <CAK=WgbbW+Kje8fMNmSAy+qM6sLcoqZcLcev8w115BfGrQzHk2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK=WgbbW+Kje8fMNmSAy+qM6sLcoqZcLcev8w115BfGrQzHk2A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ohad Ben-Cohen <ohad@wizery.com> [130118 12:58]:
> On Fri, Jan 18, 2013 at 10:42 PM, Cong Ding <dinggnu@gmail.com> wrote:
> > The pointer obj is dereferenced in line 146 and 149 respectively, so it is not
> > necessary to check null again in line 149 and 175. And I have checked that all
> > the callers of these two functions guarantee the parameter obj passed is not
> > null.
> >
> > Signed-off-by: Cong Ding <dinggnu@gmail.com>
> 
> Acked-by: Ohad Ben-Cohen <ohad@wizery.com>

Yes looks like that's a pointless check and would already obj being NULL would
fail earlier in those functions:

Acked-by: Tony Lindgren <tony@atomide.com>
