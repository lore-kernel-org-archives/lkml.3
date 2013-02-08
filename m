Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946540Ab3BHPGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 10:06:06 -0500
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:9937 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946481Ab3BHPGB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 10:06:01 -0500
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Feb 2013 10:06:01 EST
From: "Mitchell, Lisa (MCLinux in Fort Collins)" <lisa.mitchell@hp.com>
To: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
CC: "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "d.hatayama@jp.fujitsu.com" <d.hatayama@jp.fujitsu.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cpw@sgi.com" <cpw@sgi.com>
Subject: RE: [PATCH v2] Add the values related to buddy system for filtering
 free pages.
Thread-Topic: [PATCH v2] Add the values related to buddy system for
 filtering free pages.
Thread-Index: AQHOBadygQ4Mgj+1S0qBrw+tCJiY3phwDjeQ
Date: Fri, 8 Feb 2013 14:59:10 +0000
Message-ID: <D1EE06D5773FD14B8B7BE95DA4B3A74443203BCA@G4W3231.americas.hpqcorp.net>
References: <20121210103913.020858db777e2f48c59713b6@mxc.nes.nec.co.jp>
	<20121219161856.e6aa984f.akpm@linux-foundation.org>
	<20121220112103.d698c09a9d1f27a253a63d37@mxc.nes.nec.co.jp>
	<33710E6CAA200E4583255F4FB666C4E20AB2DEA3@G01JPEXMBYT03>
	<87licsrwpg.fsf@xmission.com>
	<20121227173523.5e414c342fed3e59a887fa87@mxc.nes.nec.co.jp>
	<1360240151.12251.15.camel@lisamlinux.fc.hp.com>
 <20130208114509.0755d9012cdfbcbd99c3a4ff@mxc.nes.nec.co.jp>
In-Reply-To: <20130208114509.0755d9012cdfbcbd99c3a4ff@mxc.nes.nec.co.jp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.18]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, that's good news, and thanks for the commit ID, that was the thing I was having trouble finding.

-----Original Message-----
From: Atsushi Kumagai [mailto:kumagai-atsushi@mxc.nes.nec.co.jp] 
Sent: Thursday, February 07, 2013 7:45 PM
To: Mitchell, Lisa (MCLinux in Fort Collins)
Cc: vgoyal@redhat.com; kexec@lists.infradead.org; linux-kernel@vger.kernel.org; linux-mm@kvack.org; d.hatayama@jp.fujitsu.com; ebiederm@xmission.com; akpm@linux-foundation.org; cpw@sgi.com
Subject: Re: [PATCH v2] Add the values related to buddy system for filtering free pages.

Hello Lisa,

On Thu, 07 Feb 2013 05:29:11 -0700
Lisa Mitchell <lisa.mitchell@hp.com> wrote:

> > > > Also, I have one question. Can we always think of 1st and 2nd 
> > > > kernels are same?
> > > 
> > > Not at all.  Distros frequently implement it with the same kernel 
> > > in both role but it should be possible to use an old crusty stable 
> > > kernel as the 2nd kernel.
> > > 
> > > > If I understand correctly, kexec/kdump can use the 2nd kernel 
> > > > different from the 1st's. So, differnet kernels need to do the 
> > > > same thing as makedumpfile does. If assuming two are same, problem is mush simplified.
> > > 
> > > As a developer it becomes attractive to use a known stable kernel 
> > > to capture the crash dump even as I experiment with a brand new kernel.
> > 
> > To allow to use the 2nd kernel different from the 1st's, I think we 
> > have to take care of each kernel version with the logic included in 
> > makedumpfile for them. That's to say, makedumpfile goes on as before.
> > 
> > 
> > Thanks
> > Atsushi Kumagai
> 
> 
> Atsushi and Vivek:  
> 
> I'm trying to get the status of whether the patch submitted in
> https://lkml.org/lkml/2012/11/21/90  is going to be accepted upstream
> and get in some version of the Linux 3.8 kernel.   I'm replying to the
> last email thread above on kexec_lists and lkml.org  that I could find 
> about this patch.
> 
> I was counting on this kernel patch to improve performance of 
> makedumpfilev1.5.1, so at least it wouldn't be a regression in
> performance over makedumpfile v1.4.   It was listed as recommended in
> the makedumpfilev1.5.1 release posting:
> http://lists.infradead.org/pipermail/kexec/2012-December/007460.html
> 
> 
> All the conversations in the thread since this patch was committed 
> seem to voice some reservations now, and reference other fixes being 
> tried to improve performance.
> 
> Does that mean you are abandoning getting this patch accepted 
> upstream, in favor of pursuing other alternatives?

No, this patch has been merged into -next, we should just wait for it to be merged into linus tree.

  http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=0c63e90dd1c7b35ae2ea9475ba67cf68d8801a26

What interests us now is improvement for interfaces of /proc/vmcore, it's not alternative but another idea which can be consistent with this patch.


Thanks
Atsushi Kumagai

> 
> I had hoped this patch would be okay to get accepted upstream, and 
> then other improvements could be built on top of it.
> 
> Is that not the case?   
> 
> Or has further review concluded now that this change is a bad idea due 
> to adding dependence of this new makedumpfile feature on some deep 
> kernel memory internals?
> 
> Thanks,
> 
> Lisa Mitchell
> 
>
