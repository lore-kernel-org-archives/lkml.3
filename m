Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381Ab3BMOGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 09:06:12 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:52505 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757163Ab3BMOGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 09:06:10 -0500
Message-ID: <1360764219.3524.382.camel@falcor1.watson.ibm.com>
Subject: Re: [PATCH 2/2] ima: Support appraise_type=imasig_optional
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 13 Feb 2013 09:03:39 -0500
In-Reply-To: <CALLzPKbj33dQ36tcwip_LKCOXgA6GcBDbSc5s4y4cYyv2=s=nw@mail.gmail.com>
References: <1360613493-11969-1-git-send-email-vgoyal@redhat.com>
	 <1360613493-11969-3-git-send-email-vgoyal@redhat.com>
	 <1360620614.3524.223.camel@falcor1.watson.ibm.com>
	 <20130212142636.GA23410@redhat.com>
	 <1360689247.3524.275.camel@falcor1.watson.ibm.com>
	 <20130212185203.GA29958@redhat.com>	<20130212185725.GC23410@redhat.com>
	 <CALLzPKaD==fj3GSE3SnaWg5=VVNW7A_+caFzoh=_cBv8+BVKEA@mail.gmail.com>
	 <20130213132920.GA3540@redhat.com>
	 <CALLzPKbj33dQ36tcwip_LKCOXgA6GcBDbSc5s4y4cYyv2=s=nw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021314-5518-0000-0000-00000B8C0A22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 15:36 +0200, Kasatkin, Dmitry wrote:
> It should not be the only line in the policy.
> Can you share full policy?

> On Wed, Feb 13, 2013 at 3:29 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > appraise fowner=0 func=BPRM_CHECK appraise_type=imasig_optional

Different use cases require different policies.  Our concern is that
appraising file integrity not be added to the kernel in an ad-hoc
manner.

This rule implements the intent of the original patches Vivek posted.
We might personally disagree with the intent, but that is a totally
separate discussion - one that should have been raised when he posted
the original patches.

thanks,

Mimi

