Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965472Ab3BMSU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:20:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42061 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934572Ab3BMSUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:20:50 -0500
Message-ID: <511BD923.7000500@zytor.com>
Date: Wed, 13 Feb 2013 10:19:15 -0800
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
References: <1360164359-12273-1-git-send-email-kys@microsoft.com> <20130206191313.GA1470@kroah.com> <511ADEB7.6080909@zytor.com> <ae14ef66af2d4206baf4ccb382fc4205@SN2PR03MB061.namprd03.prod.outlook.com> <20130213162211.GA21253@kroah.com> <c31482583b394bfcaa16b76a63c413fe@SN2PR03MB061.namprd03.prod.outlook.com>
In-Reply-To: <c31482583b394bfcaa16b76a63c413fe@SN2PR03MB061.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sounds like we have the joy of a cross-tree dependency...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

