Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaAOOML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 09:12:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49459 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbaAOOMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 09:12:08 -0500
Message-ID: <52D6970D.3050701@zytor.com>
Date: Wed, 15 Jan 2014 06:11:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dave Young <dyoung@redhat.com>
CC: Arjan van de Ven <arjan@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        Linux EFI <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 1/4] x86, ptdump: Add the functionality to dump an arbitrary
 pagetable
References: <1389473370-1940-1-git-send-email-bp@alien8.de> <1389473370-1940-2-git-send-email-bp@alien8.de> <20140113053240.GA11237@dhcp-16-126.nay.redhat.com> <20140113101822.GA5388@pd.tnic> <20140113122320.GA1900@darkstar.nay.redhat.com> <52D3FCAA.7070004@linux.intel.com> <20140114014003.GB4327@dhcp-16-126.nay.redhat.com> <52D57F75.7060308@zytor.com> <20140115011609.GD23767@dhcp-16-126.nay.redhat.com>
In-Reply-To: <20140115011609.GD23767@dhcp-16-126.nay.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 05:16 PM, Dave Young wrote:
>>
>> Why the [Finnish] do you feel that information needs to be in a
>> different form because it is (currently!) not available as a module?
> 
> I think moving them to comment can avoid including extra linux/module.h
> 

And that matters, why?

	-hpa

