Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966114Ab3DRIr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 04:47:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965897Ab3DRIr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 04:47:27 -0400
Date: Thu, 18 Apr 2013 10:48:10 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: Jan Beulich <JBeulich@suse.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "bp@alien8.de" <bp@alien8.de>, "apw@canonical.com" <apw@canonical.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
Message-ID: <20130418074810.GI13787@redhat.com>
References: <20130417070616.GA4487@redhat.com>
 <423ae84de75f4b3587eb2d1a365cbd95@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130417124852.GD6801@redhat.com>
 <3b76ebfdb240419aa601309465a4c154@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130417132523.GB26157@redhat.com>
 <9ffd83acf6ac4a7bb5d51c95c96e6f50@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130417134850.GB26335@redhat.com>
 <0cd5cde572734ea786664accc1a40bea@SN2PR03MB061.namprd03.prod.outlook.com>
 <516EE0FE02000078000CE422@nat28.tlf.novell.com>
 <76ae3b714d064ae392332615bfd872d5@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76ae3b714d064ae392332615bfd872d5@SN2PR03MB061.namprd03.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 04:28:36PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Jan Beulich [mailto:JBeulich@suse.com]
> > Sent: Wednesday, April 17, 2013 11:51 AM
> > To: KY Srinivasan; Michael S. Tsirkin
> > Cc: olaf@aepfle.de; bp@alien8.de; apw@canonical.com; x86@kernel.org;
> > tglx@linutronix.de; devel@linuxdriverproject.org; gregkh@linuxfoundation.org;
> > jasowang@redhat.com; linux-kernel@vger.kernel.org; hpa@zytor.com
> > Subject: RE: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
> > 
> > >>> On 17.04.13 at 17:31, KY Srinivasan <kys@microsoft.com> wrote:
> > > If Xen were to change where it would not unconditionally emulate Hyper-V, I
> > > would not be opposed to taking
> > > this check out.
> > 
> > But it doesn't do this unconditionally, only upon admin request.
> 
> >From the discussion we had a couple of months ago, the default setting was to enable
> Hyper-V emulation for all guests. If this is not the case, we ought to be able to drop this.
> However, I think it is not reasonable to add additional checks (in addition to hypervisor check)
> to customize the run-time in the guest for the specific Hypervisor.
> 
> Regards,
> 
> K. Y

Parse error. What are you trying to say? I'm just saying it's best to do
things in the way that make it possible for Xen to implement hyperv in a
more complete way in the future and have things just work
and in a way that does not change guest/hypervisor interface.

> > 
> > Jan
> > 
> > 
> 
