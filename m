Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751069Ab3LXUg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 15:36:57 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:33015 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab3LXUgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 15:36:55 -0500
Message-ID: <1387917073.1848.7.camel@misato.fc.hp.com>
Subject: Re: [PATCH v7 00/12] kexec kernel efi runtime support
From: Toshi Kani <toshi.kani@hp.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Dave Young <dyoung@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "bp@alien8.de" <bp@alien8.de>, "greg@kroah.com" <greg@kroah.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>
Date: Tue, 24 Dec 2013 13:31:13 -0700
In-Reply-To: <20131223073641.GA28919@console-pimps.org>
References: <1387533742-18018-1-git-send-email-dyoung@redhat.com>
	 <20131221173515.GE29501@console-pimps.org>
	 <1387747621.1848.2.camel@misato.fc.hp.com>
	 <20131223073641.GA28919@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-23 at 07:36 +0000, Matt Fleming wrote:
> On Sun, 22 Dec, at 02:27:01PM, Toshi Kani wrote:
> > 
> > The kexec branch is missing the following change, which is required for
> > fast reboot with multi-cpus.
> > 
> >    commit 279f1df915c3a6ed3075d98a849705bf53851f99
> >    Author: Vivek Goyal <vgoyal@redhat.com>
> >    Date:   Tue Nov 26 10:25:28 2013 +0800
> > 
> >        kexec: migrate to reboot cpu
> > 
> > With this change added, I confirmed that the branch kernel works fine.
>  
> I can't find that commit in Linus' tree. Where is it from?

Dave's git tree for the patchset has this change.  This change was
accepted by Vivek, so I think it is in his tree.

Thanks,
-Toshi


