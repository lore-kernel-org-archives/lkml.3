Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965097Ab3BMW1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 17:27:19 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:42735 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab3BMW1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 17:27:18 -0500
Message-ID: <1360794421.3524.495.camel@falcor1.watson.ibm.com>
Subject: Re: [PATCH 2/2] ima: Support appraise_type=imasig_optional
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 13 Feb 2013 17:27:01 -0500
In-Reply-To: <20130213153013.GB6750@redhat.com>
References: <1360620614.3524.223.camel@falcor1.watson.ibm.com>
	 <20130212142636.GA23410@redhat.com>
	 <1360689247.3524.275.camel@falcor1.watson.ibm.com>
	 <20130212185203.GA29958@redhat.com> <20130212185725.GC23410@redhat.com>
	 <CALLzPKaD==fj3GSE3SnaWg5=VVNW7A_+caFzoh=_cBv8+BVKEA@mail.gmail.com>
	 <20130213132920.GA3540@redhat.com>
	 <CALLzPKbj33dQ36tcwip_LKCOXgA6GcBDbSc5s4y4cYyv2=s=nw@mail.gmail.com>
	 <20130213143807.GC3540@redhat.com>
	 <CALLzPKZ=eRWDtW6eSKPX5Qbvs_N37daiULw+T7o+DpoGfw_Z_A@mail.gmail.com>
	 <20130213153013.GB6750@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 13021322-2876-0000-0000-000005428727
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 10:30 -0500, Vivek Goyal wrote:
> On Wed, Feb 13, 2013 at 05:26:27PM +0200, Kasatkin, Dmitry wrote:
> > On Wed, Feb 13, 2013 at 4:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > > On Wed, Feb 13, 2013 at 03:36:45PM +0200, Kasatkin, Dmitry wrote:
> > >> It should not be the only line in the policy.
> > >> Can you share full policy?
> > >
> > > I verified by putting some printk. There is only single rule in
> > > ima_policy_rules list after I have updated the rules through "policy"
> > > file.
> > >
> > > echo "appraise fowner=0 func=BPRM_CHECK appraise_type=imasig_optional" >
> > > /sys/kernel/security/policy
> > 
> > There is a default policy which has several rules.
> > 
> > And when you do your "echo" you will replace all rules with that single rule.
> > But ok, you have one rule only and it is fine to have even a single rule...
> 
> Yep, I got that. Default policy gets overruled when a new policy is
> loaded.
> 
> In secureboot mode, somehow above rule needs to take effect by default.
> One option would be that kernel can enforce above rule.
> (I guess by adding it to both default_list as well as policy list).

The default policy is empty, but can be replaced with boot command line
options.  The existing options are ima_tcb and/ ima_appraise_tcb.
Please feel free to define an additional policy.

thanks,

Mimi

