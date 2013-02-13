Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473Ab3BMArn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:47:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58922 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723Ab3BMArm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:47:42 -0500
Message-ID: <511AE253.7070209@zytor.com>
Date: Tue, 12 Feb 2013 16:46:11 -0800
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
References: <1360164359-12273-1-git-send-email-kys@microsoft.com> <20130206191313.GA1470@kroah.com> <511ADEB7.6080909@zytor.com> <23a161dbb5ce4a2b889a837a3cacfdca@SN2PR03MB061.namprd03.prod.outlook.com>
In-Reply-To: <23a161dbb5ce4a2b889a837a3cacfdca@SN2PR03MB061.namprd03.prod.outlook.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 04:43 PM, KY Srinivasan wrote:
>>
>> This does not apply to v3.8-rc7 + the set of three vmbus patches for
>> x86.  I take it there are additional dependencies -- K.Y., what do I
>> need here?
> 
> Do none of the earlier patches apply or just this patch. If none of them
> apply, I could rebase all of them and resend them. Please let me know.
> 

The earlier (set of 3) patches apply just fine.

	-hpa


