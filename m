Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934160Ab3BMP0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 10:26:30 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57353 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934077Ab3BMP02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 10:26:28 -0500
MIME-Version: 1.0
In-Reply-To: <20130213143807.GC3540@redhat.com>
References: <1360613493-11969-1-git-send-email-vgoyal@redhat.com>
	<1360613493-11969-3-git-send-email-vgoyal@redhat.com>
	<1360620614.3524.223.camel@falcor1.watson.ibm.com>
	<20130212142636.GA23410@redhat.com>
	<1360689247.3524.275.camel@falcor1.watson.ibm.com>
	<20130212185203.GA29958@redhat.com>
	<20130212185725.GC23410@redhat.com>
	<CALLzPKaD==fj3GSE3SnaWg5=VVNW7A_+caFzoh=_cBv8+BVKEA@mail.gmail.com>
	<20130213132920.GA3540@redhat.com>
	<CALLzPKbj33dQ36tcwip_LKCOXgA6GcBDbSc5s4y4cYyv2=s=nw@mail.gmail.com>
	<20130213143807.GC3540@redhat.com>
Date: Wed, 13 Feb 2013 17:26:27 +0200
Message-ID: <CALLzPKZ=eRWDtW6eSKPX5Qbvs_N37daiULw+T7o+DpoGfw_Z_A@mail.gmail.com>
Subject: Re: [PATCH 2/2] ima: Support appraise_type=imasig_optional
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 4:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Feb 13, 2013 at 03:36:45PM +0200, Kasatkin, Dmitry wrote:
>> It should not be the only line in the policy.
>> Can you share full policy?
>
> I verified by putting some printk. There is only single rule in
> ima_policy_rules list after I have updated the rules through "policy"
> file.
>
> echo "appraise fowner=0 func=BPRM_CHECK appraise_type=imasig_optional" >
> /sys/kernel/security/policy

There is a default policy which has several rules.

And when you do your "echo" you will replace all rules with that single rule.
But ok, you have one rule only and it is fine to have even a single rule...

>
> Thanks
> Vivek
