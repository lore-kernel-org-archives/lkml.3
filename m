Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab3DQPST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 11:18:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56033 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab3DQPSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 11:18:18 -0400
Message-ID: <516EBD1C.3030902@zytor.com>
Date: Wed, 17 Apr 2013 08:17:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "bp@alien8.de" <bp@alien8.de>, "apw@canonical.com" <apw@canonical.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        KY Srinivasan <kys@microsoft.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
References: <1359940910-32114-1-git-send-email-kys@microsoft.com> <1359940959-32168-1-git-send-email-kys@microsoft.com> <1359940959-32168-2-git-send-email-kys@microsoft.com> <20130417070616.GA4487@redhat.com> <423ae84de75f4b3587eb2d1a365cbd95@SN2PR03MB061.namprd03.prod.outlook.com> <516EC54A02000078000CE2AE@nat28.tlf.novell.com> <20130417130102.GE6801@redhat.com> <516EC93D02000078000CE30A@nat28.tlf.novell.com>
In-Reply-To: <516EC93D02000078000CE30A@nat28.tlf.novell.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2013 07:09 AM, Jan Beulich wrote:
> 
> Iirc it was/is XenServer which enable Hyper-V emulation for all HVM
> guests, which clearly is the wrong thing. I was personally also not
> really in agreement with the override in the kernel, but it was
> decided to do it that way at that point in time. As a consequence,
> I don't object this to be reverted.
> 

I was not exactly happy with the idea either.  I'm sorry if I mixed up
Xen and KVM.

Furthermore, as I recall, it only affected kernels where Xen was
compiled out, or something like that.

It would definitely be best to fix the HyperV driver to be more
robust... that may be important across HyperV releases, too.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

