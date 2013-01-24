Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab3AXTcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:32:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33670 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab3AXTch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:32:37 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20130124192359.GA22484@aepfle.de>
References: <1358990259-22551-1-git-send-email-kys@microsoft.com> <5101035D02000078000B8FFD@nat28.tlf.novell.com> <27092660926e4d3f80394697cc0dc858@SN2PR03MB061.namprd03.prod.outlook.com> <51016C3202000078000B943E@nat28.tlf.novell.com> <f6cbfec9c014433fa54af61d8f436ebb@SN2PR03MB061.namprd03.prod.outlook.com> <20130124185943.GA19194@aepfle.de> <4d9be218-acf5-45a6-aeda-cee592fd74c8@email.android.com> <20130124192359.GA22484@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND 1/1] X86: Handle Hyper-V vmbus interrupts as special hypervisor interrupts
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 24 Jan 2013 13:30:52 -0600
To: Olaf Hering <olaf@aepfle.de>
CC: KY Srinivasan <kys@microsoft.com>, Jan Beulich <JBeulich@suse.com>,
        "bp@alien8.de" <bp@alien8.de>, "apw@canonical.com" <apw@canonical.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <e8da7a46-c0f6-4590-87a4-e9860fb4ccab@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And there is no evidence of Xen in CPUID?

Olaf Hering <olaf@aepfle.de> wrote:

>On Thu, Jan 24, H. Peter Anvin wrote:
>
>> Can't you discover Xen emulation by looking for Xen first?  Or does
>Xen go "stealth"?
>
>The current code looks at cpuid to decide what the host type is. One
>thing to detect a Xen host is to look for the DIM strings, which still
>have "Xen HVM DomU" or similar.
>
>Olaf

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
