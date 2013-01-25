Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab3AYHby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 02:31:54 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:36820 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab3AYHbs convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:10:1>);
	Fri, 25 Jan 2013 02:31:48 -0500
Message-Id: <510242EF02000078000B96FD@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Fri, 25 Jan 2013 07:31:43 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "KY Srinivasan" <kys@microsoft.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "olaf@aepfle.de" <olaf@aepfle.de>, "bp@alien8.de" <bp@alien8.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RESEND 1/1] X86: Handle Hyper-V vmbus interrupts as
 special hypervisor interrupts
References: <1358990259-22551-1-git-send-email-kys@microsoft.com>
 <5101035D02000078000B8FFD@nat28.tlf.novell.com>
 <27092660926e4d3f80394697cc0dc858@SN2PR03MB061.namprd03.prod.outlook.com>
 <51016C3202000078000B943E@nat28.tlf.novell.com>
 <f6cbfec9c014433fa54af61d8f436ebb@SN2PR03MB061.namprd03.prod.outlook.com>
 <52cb66cd-8a8f-461c-adc4-0026afb8c1fd@email.android.com>
In-Reply-To: <52cb66cd-8a8f-461c-adc4-0026afb8c1fd@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 24.01.13 at 20:10, "H. Peter Anvin" <hpa@zytor.com> wrote:
> I also have to point out the obvious problem with Xen masquerading as HyperV 
> without implementing the same feature set...

I can't resist to state that this is what feature bits have been
introduced for in CPUID leaves. As long as Xen's shim doesn't
advertise a feature bit it doesn't implement, all should be fine.

Jan

