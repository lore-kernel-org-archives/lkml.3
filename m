Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab3AXTAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:00:06 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:60813 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab3AXTAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:00:02 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/ll3c7qES2M
X-RZG-CLASS-ID: mo00
Date: Thu, 24 Jan 2013 19:59:43 +0100
From: Olaf Hering <olaf@aepfle.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: Jan Beulich <JBeulich@suse.com>, "bp@alien8.de" <bp@alien8.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH RESEND 1/1] X86: Handle Hyper-V vmbus interrupts as
 special hypervisor interrupts
Message-ID: <20130124185943.GA19194@aepfle.de>
References: <1358990259-22551-1-git-send-email-kys@microsoft.com>
 <5101035D02000078000B8FFD@nat28.tlf.novell.com>
 <27092660926e4d3f80394697cc0dc858@SN2PR03MB061.namprd03.prod.outlook.com>
 <51016C3202000078000B943E@nat28.tlf.novell.com>
 <f6cbfec9c014433fa54af61d8f436ebb@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f6cbfec9c014433fa54af61d8f436ebb@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21.rev5632 (2013-01-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, KY Srinivasan wrote:


> > Question is - considering you stated that this is supported
> > starting in Win8, doesn't Hyper-V itself announce that
> > capability in some explicit way?
> 
> Thanks Jan. Unfortunately I don't think tis interrupt delivery model
> is specified via a "feature" bit (I will check with the Windows guys).
> Perhaps, we can have a Hyper-V specific compilation switch to address
> the Xen emulation issue.

Would that really help if both pvops XEN_PVHVM and HYPERV are enabled in
the config? I assume at this point the access to the DMI data is not yet
possible.

Olaf
