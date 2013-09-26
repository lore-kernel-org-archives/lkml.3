Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab3IZVDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 17:03:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55369 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab3IZVDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 17:03:06 -0400
Message-ID: <5244A0E2.3080902@zytor.com>
Date: Thu, 26 Sep 2013 14:02:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        msharbiani@twitter.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/reboot] x86/reboot: Remove the duplicate C6100 entry
 in the reboot quirks list
References: <1380216643-4683-1-git-send-email-masoud.sharbiani@gmail.com>  <tip-b5eafc6f07c95e9f3dd047e72737449cb03c9956@git.kernel.org> <1380229154.2170.13.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1380229154.2170.13.camel@buesod1.americas.hpqcorp.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 01:59 PM, Davidlohr Bueso wrote:
>> -	},
>> -	{	/* Some C6100 machines were shipped with vendor being 'Dell'. */
>> -		.callback = set_pci_reboot,
>> -		.ident = "Dell PowerEdge C6100",
>> -		.matches = {
>>  			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
>>  			DMI_MATCH(DMI_PRODUCT_NAME, "C6100"),
>>  		},
> 
> Hmm, I think we should be keeping the 'Dell Inc.' part instead of just
> 'Dell' - at least the rest of the entries use the same string:
> 

The point is that some of the machines just has "Dell" in their vendor
string.

	-hpa


