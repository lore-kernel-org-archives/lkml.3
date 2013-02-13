Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934251Ab3BMPxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 10:53:32 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:45006 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759765Ab3BMPxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 10:53:31 -0500
Message-ID: <1360770675.3524.400.camel@falcor1.watson.ibm.com>
Subject: Re: [PATCH 2/2] ima: Support appraise_type=imasig_optional
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 13 Feb 2013 10:51:15 -0500
In-Reply-To: <20130213143807.GC3540@redhat.com>
References: <1360613493-11969-1-git-send-email-vgoyal@redhat.com>
	 <1360613493-11969-3-git-send-email-vgoyal@redhat.com>
	 <1360620614.3524.223.camel@falcor1.watson.ibm.com>
	 <20130212142636.GA23410@redhat.com>
	 <1360689247.3524.275.camel@falcor1.watson.ibm.com>
	 <20130212185203.GA29958@redhat.com> <20130212185725.GC23410@redhat.com>
	 <CALLzPKaD==fj3GSE3SnaWg5=VVNW7A_+caFzoh=_cBv8+BVKEA@mail.gmail.com>
	 <20130213132920.GA3540@redhat.com>
	 <CALLzPKbj33dQ36tcwip_LKCOXgA6GcBDbSc5s4y4cYyv2=s=nw@mail.gmail.com>
	 <20130213143807.GC3540@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021315-3620-0000-0000-00000136253F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 09:38 -0500, Vivek Goyal wrote:
> On Wed, Feb 13, 2013 at 03:36:45PM +0200, Kasatkin, Dmitry wrote:
> > It should not be the only line in the policy.
> > Can you share full policy?
> 
> I verified by putting some printk. 

If anyone is interested in posting a patch to display the current
policy, it shouldn't be too difficult to do.

> There is only single rule in
> ima_policy_rules list after I have updated the rules through "policy"
> file.

> echo "appraise fowner=0 func=BPRM_CHECK appraise_type=imasig_optional" >
> /sys/kernel/security/policy

Right, this replaces one policy with another one.

thanks,

Mimi

