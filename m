Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab3BMBBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 20:01:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59299 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757219Ab3BMBB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 20:01:29 -0500
Message-ID: <511AE583.5060002@zytor.com>
Date: Tue, 12 Feb 2013 16:59:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: KY Srinivasan <kys@microsoft.com>
CC: Greg KH <gregkh@linuxfoundation.org>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "JBeulich@suse.com" <JBeulich@suse.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for
 delivering VMBUS interrupts
References: <1360164359-12273-1-git-send-email-kys@microsoft.com> <20130206191313.GA1470@kroah.com> <511ADEB7.6080909@zytor.com> <23a161dbb5ce4a2b889a837a3cacfdca@SN2PR03MB061.namprd03.prod.outlook.com> <511AE253.7070209@zytor.com> <508f13bedcb4478486c751a91ef8154b@SN2PR03MB061.namprd03.prod.outlook.com>
In-Reply-To: <508f13bedcb4478486c751a91ef8154b@SN2PR03MB061.namprd03.prod.outlook.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 04:50 PM, KY Srinivasan wrote:
> 
> Apply them and I will rebase this patch and send it out.
> 

Pull the -tip tree and you can base it on the x86/hyperv branch.

	-hpa


