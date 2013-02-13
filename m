Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab3BMSib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:38:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42951 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab3BMSia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:38:30 -0500
Message-ID: <511BDD2A.8020002@zytor.com>
Date: Wed, 13 Feb 2013 10:36:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: KY Srinivasan <kys@microsoft.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "JBeulich@suse.com" <JBeulich@suse.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for
 delivering VMBUS interrupts
References: <1360164359-12273-1-git-send-email-kys@microsoft.com> <20130206191313.GA1470@kroah.com> <511ADEB7.6080909@zytor.com> <ae14ef66af2d4206baf4ccb382fc4205@SN2PR03MB061.namprd03.prod.outlook.com> <20130213162211.GA21253@kroah.com> <c31482583b394bfcaa16b76a63c413fe@SN2PR03MB061.namprd03.prod.outlook.com> <511BD923.7000500@zytor.com> <20130213182349.GA4959@kroah.com>
In-Reply-To: <20130213182349.GA4959@kroah.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 10:23 AM, Greg KH wrote:
> On Wed, Feb 13, 2013 at 10:19:15AM -0800, H. Peter Anvin wrote:
>> Sounds like we have the joy of a cross-tree dependency...
> 
> Yeah, a mess.
> 
> KY, how about I just wait until all of this gets merged with Linus for
> 3.9-rc1, and then you resend me the patches you have to take advantage
> of these new bits?  That makes it easy for everyone involved.
> 

The other option is you can pull tip:x86/hyperv from me... it has *only*
these changes.  I can then let you push them to Linus or I can push them
to Linus before you push your tree.

	-hpa


