Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934197Ab3BMPjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 10:39:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757615Ab3BMPjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 10:39:48 -0500
Date: Wed, 13 Feb 2013 10:39:05 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ima: Support appraise_type=imasig_optional
Message-ID: <20130213153905.GC6750@redhat.com>
References: <20130212142636.GA23410@redhat.com>
 <1360689247.3524.275.camel@falcor1.watson.ibm.com>
 <20130212185203.GA29958@redhat.com>
 <20130212185725.GC23410@redhat.com>
 <CALLzPKaD==fj3GSE3SnaWg5=VVNW7A_+caFzoh=_cBv8+BVKEA@mail.gmail.com>
 <20130213132920.GA3540@redhat.com>
 <CALLzPKbj33dQ36tcwip_LKCOXgA6GcBDbSc5s4y4cYyv2=s=nw@mail.gmail.com>
 <20130213143807.GC3540@redhat.com>
 <CALLzPKZ=eRWDtW6eSKPX5Qbvs_N37daiULw+T7o+DpoGfw_Z_A@mail.gmail.com>
 <CALLzPKY-QJmxSUDdRF9V+pjEZhVb_UcGnJsqxiUiJ=YKTr0YWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLzPKY-QJmxSUDdRF9V+pjEZhVb_UcGnJsqxiUiJ=YKTr0YWg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 05:29:43PM +0200, Kasatkin, Dmitry wrote:
> On Wed, Feb 13, 2013 at 5:26 PM, Kasatkin, Dmitry
> <dmitry.kasatkin@intel.com> wrote:
> > On Wed, Feb 13, 2013 at 4:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> On Wed, Feb 13, 2013 at 03:36:45PM +0200, Kasatkin, Dmitry wrote:
> >>> It should not be the only line in the policy.
> >>> Can you share full policy?
> >>
> >> I verified by putting some printk. There is only single rule in
> >> ima_policy_rules list after I have updated the rules through "policy"
> >> file.
> >>
> >> echo "appraise fowner=0 func=BPRM_CHECK appraise_type=imasig_optional" >
> >> /sys/kernel/security/policy
> >
> > There is a default policy which has several rules.
> >
> > And when you do your "echo" you will replace all rules with that single rule.
> > But ok, you have one rule only and it is fine to have even a single rule...
> >
> 
> What I have not said yet it is that in your case, because you use only
> BPRM_CHECK hook,
> you do not need "dont_appraise" and "dont_measure" rules for pseudo filesystems.

Agreed.

Thanks
Vivek
