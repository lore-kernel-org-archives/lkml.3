Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab3AYHaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 02:30:25 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:36781 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab3AYHaX convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:10:1>);
	Fri, 25 Jan 2013 02:30:23 -0500
Message-Id: <5102429A02000078000B96FA@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Fri, 25 Jan 2013 07:30:18 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Olaf Hering" <olaf@aepfle.de>, "KY Srinivasan" <kys@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "bp@alien8.de" <bp@alien8.de>, "apw@canonical.com" <apw@canonical.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND 1/1] X86: Handle Hyper-V vmbus interrupts as
 special hypervisor interrupts
References: <1358990259-22551-1-git-send-email-kys@microsoft.com>
 <5101035D02000078000B8FFD@nat28.tlf.novell.com>
 <27092660926e4d3f80394697cc0dc858@SN2PR03MB061.namprd03.prod.outlook.com>
 <51016C3202000078000B943E@nat28.tlf.novell.com>
 <f6cbfec9c014433fa54af61d8f436ebb@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130124185943.GA19194@aepfle.de>
 <4d9be218-acf5-45a6-aeda-cee592fd74c8@email.android.com>
In-Reply-To: <4d9be218-acf5-45a6-aeda-cee592fd74c8@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 24.01.13 at 20:04, "H. Peter Anvin" <hpa@zytor.com> wrote:
> Can't you discover Xen emulation by looking for Xen first?  Or does Xen go 
> "stealth"?

That's already being done - the ordering currently is Xen, VMWare,
Hyper-V, KVM. I.e. there's only a problem when !CONFIG_XEN_PVHVM.

Jan

