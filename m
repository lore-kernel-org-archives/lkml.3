Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab3IRFoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 01:44:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256Ab3IRFoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 01:44:05 -0400
Date: Wed, 18 Sep 2013 08:43:35 +0300
From: Gleb Natapov <gleb@redhat.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "JBeulich@suse.com" <JBeulich@suse.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
 from the hypervisor
Message-ID: <20130918054335.GE5657@redhat.com>
References: <1378233023-4512-1-git-send-email-kys@microsoft.com>
 <dd29077371564a14b2d317d2291db8a9@SN2PR03MB061.namprd03.prod.outlook.com>
 <52325C1E.90101@zytor.com>
 <50f92d9c16a54e5bb6fa14ef72e5fdfb@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130913095526.GE18381@redhat.com>
 <7737cb643a664b6fb39021b4d364b5cf@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130917135918.GY17294@redhat.com>
 <2b4a9a0cff5143c59a0802a2e425c4db@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b4a9a0cff5143c59a0802a2e425c4db@SN2PR03MB061.namprd03.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 07:53:36PM +0000, KY Srinivasan wrote:
> > > Thanks Gleb. Here is the link for the latest Hyper-V specification:
> > > http://www.microsoft.com/en-us/download/details.aspx?id=39289
> > >
> > > This spec talks about how migration is handled with regards to TSC.
> > >
> > All I can see is "15.4.3 Partition Reference TSC Mechanism". I see
> > nothing about HV_X64_MSR_TSC_FREQUENCY specifically. To access this MSR
> > a partition needs AccessFrequencyMsrs privilege, may be partition that
> > cab be migrated does not have this privilege?
> 
> If you use the MSR to read the TSC frequency, then indeed when you migrate then there
> is no guarantee that the TSC frequency won't change when you migrate. The approach
> described in section 15.4.3 is the preferred approach that can accommodate migration.
> 
Thanks.

--
			Gleb.
