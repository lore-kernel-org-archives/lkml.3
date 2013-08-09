Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055Ab3HINBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 09:01:43 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19418 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab3HINBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:01:41 -0400
Date: Fri, 9 Aug 2013 09:00:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        mingo@redhat.com, jeremy@goop.org, x86@kernel.org, pbonzini@redhat.com,
        linux-doc@vger.kernel.org, habanero@linux.vnet.ibm.com,
        xen-devel@lists.xensource.com, peterz@infradead.org,
        mtosatti@redhat.com, stefano.stabellini@eu.citrix.com,
        andi@firstfloor.org, attilio.rao@citrix.com, ouyang@cs.pitt.edu,
        gregkh@suse.de, agraf@suse.de, chegu_vinod@hp.com,
        torvalds@linux-foundation.org, avi.kivity@gmail.com,
        tglx@linutronix.de, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH  V12 0/14] Paravirtualized ticket spinlocks
Message-ID: <20130809130015.GA3730@phenom.dumpdata.com>
References: <20130806114020.20643.57235.sendpatchset@codeblue.in.ibm.com>
 <52016412.1020608@zytor.com>
 <5201B6FB.5080807@linux.vnet.ibm.com>
 <5201D180.9080005@zytor.com>
 <5201ED01.7000803@linux.vnet.ibm.com>
 <20130808005012.GI2810@phenom.dumpdata.com>
 <20130808010251.GJ15901@redhat.com>
 <52040A05.5080107@zytor.com>
 <520423E9.80507@zytor.com>
 <5204E57A.3000002@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5204E57A.3000002@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 06:20:02PM +0530, Raghavendra K T wrote:
> On 08/09/2013 04:34 AM, H. Peter Anvin wrote:
> >
> >Okay, I figured it out.
> >
> >One of several problems with the formatting of this patchset is that it
> >has one- and two-digit patch numbers in the headers, which meant that my
> >scripts tried to apply patch 10 first.
> >
> 
> My bad. I 'll send out in uniform digit form next time.
> 

If you use 'git format-patch --subject-prefix "PATCH V14" v3.11-rc4..'
and 'git send-email --subject "[PATCH V14] bla blah" ..'
that should be automatically taken care of?

