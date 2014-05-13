Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaEMRSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 13:18:16 -0400
Received: from smtp.citrix.com ([66.165.176.89]:40608 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670AbaEMRSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 13:18:03 -0400
X-IronPort-AV: E=Sophos;i="4.97,1044,1389744000"; 
   d="scan'208";a="130746660"
Message-ID: <537253C8.7000401@citrix.com>
Date: Tue, 13 May 2014 18:18:00 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        <linux-kernel@vger.kernel.org>
CC: Andrew Jones <drjones@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH] xen/x86: set panic notifier priority to minimum
References: <1400000185-15148-1-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1400000185-15148-1-git-send-email-rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/05/14 17:56, Radim Krčmář wrote:
> Execution is not going to continue after telling Xen about the crash.
> Let other panic notifiers run by postponing the final hypercall as much
> as possible.

I can't tell how important this fix is.

What notifiers does this allow to be run?  How important are they?

David

