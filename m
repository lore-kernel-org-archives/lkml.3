Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaEGRFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 13:05:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51284 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbaEGRFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 13:05:32 -0400
Message-ID: <536A67B8.1080805@zytor.com>
Date: Wed, 07 May 2014 10:04:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "David E. Box" <david.e.box@linux.intel.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        kristen.c.accardi@intel.com, jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v3] x86/iosf: Make IOSF driver modular and usable by more
 drivers
References: <1398810789-2301-1-git-send-email-david.e.box@linux.intel.com>	<1399052199-8703-1-git-send-email-david.e.box@linux.intel.com> <20140507174801.20fc0d67@alan.etchedpixels.co.uk>
In-Reply-To: <20140507174801.20fc0d67@alan.etchedpixels.co.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 09:48 AM, One Thousand Gnomes wrote:
> On Fri,  2 May 2014 10:36:39 -0700
>> +bool iosf_mbi_available(void)
>> +{
>> +	return mbi_pdev;
>> +}
>> +EXPORT_SYMBOL(iosf_mbi_available);
> 
> Probably worth a follow up patch that comments this so the assumption
> that iosf can never be unloaded or hot-unplugged is clear.
> 

When you say unloaded you mean the module or the hardware?

	-hpa


