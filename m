Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab3AWPif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:38:35 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22556 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893Ab3AWPic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:38:32 -0500
Date: Wed, 23 Jan 2013 10:37:25 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: KY Srinivasan <kys@microsoft.com>, Borislav Petkov <bp@alien8.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, "jeremy@goop.org" <jeremy@goop.org>,
        "Jan Beulich (JBeulich@suse.com)" <JBeulich@suse.com>
Subject: Re: [PATCH 1/1] X86: Handle Hyper-V vmbus interrupts as special
 hypervisor interrupts
Message-ID: <20130123153725.GJ3067@phenom.dumpdata.com>
References: <1358469577-8794-1-git-send-email-kys@microsoft.com>
 <20130118131056.GA14550@pd.tnic>
 <794a590acf1a47408a87e95f095e6b1b@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130122222056.GC14503@phenom.dumpdata.com>
 <2bd8c994-3e70-413b-85de-caec46428b1e@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bd8c994-3e70-413b-85de-caec46428b1e@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 05:19:37PM -0600, H. Peter Anvin wrote:
> Yes, how about we rename this the hypervisor vector...

HYPERVISOR_CALLBACK_VECTOR ?
