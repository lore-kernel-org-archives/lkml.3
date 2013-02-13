Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964897Ab3BMSXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:23:54 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62808 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964817Ab3BMSXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:23:53 -0500
Date: Wed, 13 Feb 2013 10:23:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: KY Srinivasan <kys@microsoft.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "JBeulich@suse.com" <JBeulich@suse.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for
 delivering VMBUS interrupts
Message-ID: <20130213182349.GA4959@kroah.com>
References: <1360164359-12273-1-git-send-email-kys@microsoft.com>
 <20130206191313.GA1470@kroah.com>
 <511ADEB7.6080909@zytor.com>
 <ae14ef66af2d4206baf4ccb382fc4205@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130213162211.GA21253@kroah.com>
 <c31482583b394bfcaa16b76a63c413fe@SN2PR03MB061.namprd03.prod.outlook.com>
 <511BD923.7000500@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511BD923.7000500@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 10:19:15AM -0800, H. Peter Anvin wrote:
> Sounds like we have the joy of a cross-tree dependency...

Yeah, a mess.

KY, how about I just wait until all of this gets merged with Linus for
3.9-rc1, and then you resend me the patches you have to take advantage
of these new bits?  That makes it easy for everyone involved.

thanks,

greg k-h
