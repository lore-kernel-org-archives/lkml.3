Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbbAOFUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 00:20:39 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40663 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896AbbAOFUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 00:20:37 -0500
Date: Wed, 14 Jan 2015 21:20:28 -0800
From: Calvin Owens <calvinowens@fb.com>
To: Paul Moore <paul@paul-moore.com>, <rgb@redhat.com>
CC: Eric Paris <eparis@redhat.com>, <ebiederm@xmission.com>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        <stable@vger.kernel.org>, <linux-audit@redhat.com>
Subject: Re: [PATCH][RESEND 2] Revert "AUDIT: Allow login in non-init
 namespaces"
Message-ID: <20150115052028.GA15348@mail.thefacebook.com>
References: <1415148371-11742-1-git-send-email-calvinowens@fb.com>
 <1569326.X07DWxmoQX@sifl>
 <20150109212451.GG27996@mail.thefacebook.com>
 <4124626.alCBS2pqnO@sifl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <4124626.alCBS2pqnO@sifl>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-15_02:2015-01-14,2015-01-15,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=5.57331958361829e-14 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.925924926977281
 urlsuspect_oldscore=0.925924926977281 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.925924926977281 spamscore=0
 recipient_to_sender_domain_totalscore=2 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501150054
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01/09 at 16:36 -0500, Paul Moore wrote:
> On Friday, January 09, 2015 01:24:51 PM Calvin Owens wrote:
> > On Friday 01/09 at 15:33 -0500, Paul Moore wrote:
> > > While I haven't had reason to test this code lately, last I knew it was
> > > working, what problems are you seeing Calvin?  Also, with what
> > > distribution?
> >
> > An SSH authentication setup in LXC containers on CentOS broke with the
> > original patch. My revert made it work again. I can dig up more detail
> > about the specific setup if you're interested.
> 
> Yes, please.  I believe it is the little details that are important for this 
> issue.

Just drop this patch, I goofed up. Sorry for the noise.

(543bc6a1a987 was mistakingly applied to a kernel build without the
supporting patches mentioned in the commit message. It was stupid of me
not to check for that before bothering you...)

Thanks very much,
Calvin
 
> -- 
> paul moore
> www.paul-moore.com
> 
