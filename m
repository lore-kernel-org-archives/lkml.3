Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717Ab3KMS1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 13:27:35 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:34184 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951Ab3KMS11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 13:27:27 -0500
Date: Wed, 13 Nov 2013 11:27:21 -0700
From: jerry.hoemann@hp.com
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: hpa@linux.intel.com, ebiederm@xmission.com, vgoyal@redhat.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        akpm@linux-foundation.org, fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v4 0/3] x86, apic, kexec: Add disable_cpu_apic kernel
 parameter
Message-ID: <20131113182721.GB10062@anatevka.fc.hp.com>
Reply-To: jerry.hoemann@hp.com
References: <20131022150015.24240.39686.stgit@localhost6.localdomain6>
 <20131106190232.GA28119@anatevka.fc.hp.com>
 <528061E5.7010903@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528061E5.7010903@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 01:49:41PM +0900, HATAYAMA Daisuke wrote:
> 
> Thanks for your testing.
> 
> >I have seen no issues w/ the 3.0.80 dump testing on our proto.
> >
> >On the 2.6.32 testing on our proto, i have hit a low probability (< 5%)
> >chance of the capture suffering a soft lockup hang during
> >"Switching to clocksource hpet."  I have not RCA'd this yet.
> >Note, I have seen this issue on earlier version of the patch, so
> >it is not specific to this version.
> >
> >I then tested the 2.6.32 port on a dl380.  This worked without issue.
> >
> >Note, I have seen no issues related to this patch on our proto when
> >booting the capture with a single processor.
> >
> >While I am still pursuing the issue of the 2.6.32 kernel on our proto,
> >I believe this patch is good and should be accepted.
> >
> 
> This seems there's something that depends on the system you used. But I
> have never verified my patch set on 2.6.32-based kernel. I'll try to
> do a similar test on some FJ systems.
> 
> The 2.6.32-based kernel you mean is one of the Longterm release kernels,
> right? So, you used on the test the 2.6.32-based Longterm release kernel
> with my v4 patch, right?


I've been using 2.6.32 and 3.0.80 based kernels from different distros.
These are not the same as long term kernels on kernel.org.


I see you've posted an updated version of the patch.  i've picked it
up and will test.


-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard/MODL

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann@hp.com
----------------------------------------------------------------------------

