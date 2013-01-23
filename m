Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab3AWQGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 11:06:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47318 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755947Ab3AWQGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:06:41 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20130123153725.GJ3067@phenom.dumpdata.com>
References: <1358469577-8794-1-git-send-email-kys@microsoft.com> <20130118131056.GA14550@pd.tnic> <794a590acf1a47408a87e95f095e6b1b@SN2PR03MB061.namprd03.prod.outlook.com> <20130122222056.GC14503@phenom.dumpdata.com> <2bd8c994-3e70-413b-85de-caec46428b1e@email.android.com> <20130123153725.GJ3067@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] X86: Handle Hyper-V vmbus interrupts as special hypervisor interrupts
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 23 Jan 2013 10:04:49 -0600
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: KY Srinivasan <kys@microsoft.com>, Borislav Petkov <bp@alien8.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, "jeremy@goop.org" <jeremy@goop.org>,
        "Jan Beulich (JBeulich@suse.com)" <JBeulich@suse.com>
Message-ID: <7fd5fe02-98d8-4ec1-81c5-741983262b77@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sounds good to me.

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

>On Tue, Jan 22, 2013 at 05:19:37PM -0600, H. Peter Anvin wrote:
>> Yes, how about we rename this the hypervisor vector...
>
>HYPERVISOR_CALLBACK_VECTOR ?

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
