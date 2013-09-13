Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab3IMJ4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 05:56:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756258Ab3IMJ4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 05:56:00 -0400
Date: Fri, 13 Sep 2013 12:55:26 +0300
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
Message-ID: <20130913095526.GE18381@redhat.com>
References: <1378233023-4512-1-git-send-email-kys@microsoft.com>
 <dd29077371564a14b2d317d2291db8a9@SN2PR03MB061.namprd03.prod.outlook.com>
 <52325C1E.90101@zytor.com>
 <50f92d9c16a54e5bb6fa14ef72e5fdfb@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50f92d9c16a54e5bb6fa14ef72e5fdfb@SN2PR03MB061.namprd03.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 01:43:09AM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: H. Peter Anvin [mailto:hpa@zytor.com]
> > Sent: Thursday, September 12, 2013 5:28 PM
> > To: KY Srinivasan
> > Cc: x86@kernel.org; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > jasowang@redhat.com; tglx@linutronix.de; JBeulich@suse.com; bp@alien8.de
> > Subject: Re: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
> > from the hypervisor
> > 
> > On 09/12/2013 05:06 PM, KY Srinivasan wrote:
> > >
> > > Peter,
> > >
> > > Let me know if you want me to address any additional issues in this patch.
> > >
> > 
> > Please address Jan and Gleb's feedback.
> 
> Gleb's feedback was a question and I answered that as I did Jan's feedback as well.
> Gleb, Jan, please let me know if there is something else you want addressed here.
> 
No, I am just interesting to know some details about the interface since
I cannot find it documented in Hyper-V spec.

--
			Gleb.
