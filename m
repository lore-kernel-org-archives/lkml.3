Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaGJOst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:48:49 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27144 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaGJOsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:48:47 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-a8-53bea7cd58bb
Message-id: <53BEA780.5050602@samsung.com>
Date: Thu, 10 Jul 2014 17:47:28 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>
Cc: keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: Re: [PATCH v6 0/6] ima: extending secure boot certificate chain of
 trust
References: <1404924054.14643.36.camel@dhcp-9-2-203-236.watson.ibm.com>
 <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
 <24144.1404919879@warthog.procyon.org.uk>
 <8975.1404932208@warthog.procyon.org.uk>
 <1404941347.14643.57.camel@dhcp-9-2-203-236.watson.ibm.com>
In-reply-to: <1404941347.14643.57.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t/xK7pnl+8LNng8n8PiXdNvFosvS+ss
	Drx7wmIxe9dDFovLu+awWXzoecRmcfXhbBaLTysmMTtweOycdZfdY9qJZSweDw5tZvF4v+8q
	m8e6G1/ZPT5vkgtgi+KySUnNySxLLdK3S+DKeNDoVXCWo+LFmZPMDYx/2boYOTkkBEwkHv97
	BGWLSVy4tx7I5uIQEljKKLG/5wgjhNPIJDH7yE9WkCohgVmMEq8OuIDYvAJaEhfvP2IHsVkE
	VCVudr5nBrHZBPQkNjT/AIuLCkRIHOh7xgpRLyjxY/I9FhBbRMBP4uGZF2D1zAJ9TBJ3Nol2
	MXJwCAsES5x9pw+xajaTxKmjFiA2p4CHxMrz+6HK1SUmzVsEZctLbF7zlhmiXlWie+1aqGcU
	JU5PPsc8gVF4FpLNs5C0z0LSvoCReRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGSPR83cG4
	9JjVIUYBDkYlHt4Xu/cEC7EmlhVX5h5ilOBgVhLhvbJoX7AQb0piZVVqUX58UWlOavEhRiYO
	TqkGRkH9/a5O4pd/7VxhOIv1ucavVWFR6ddc9vOtPrrAa7pfkLKYyctrmgv6L9ev3nFMkf/S
	3gd1F11aUxcZqvpNfX/kWE7GhndlEbsMkznnFWlplmzOLOzxkhP/8mDLrteZM3mzDJ9zn3oS
	xHM+1fGetZvj6x2HpD7fslR0fmGw9I9c/ZpJwVkLTiixFGckGmoxFxUnAgAx8zMHfAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

If patches from integrity/next-trusted-keys goes via your tree, then I
suggest that you re-base your patches on the top of our
patchset, because it is unclear how long review of PE, PKCS7 patches
will take and if they will be pulled...

I would do it with different pull requests.

- Dmitry


On 10/07/14 00:29, Mimi Zohar wrote:
> On Wed, 2014-07-09 at 19:56 +0100, David Howells wrote: 
>> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>>
>>> Yes, that's fine.  My concern, however, is that the trusted keyring
>>> patches are independent of the other patches being upstreamed and should
>>> be upstreamed regardless of the other patches.
>> There is overlap in the X.509 certificate request function that you took from
>> my pkcs#7 patches.
> Right, x509_request_asymmetric_key() is the same as
> pkcs7_request_asymmetric_key().
>
> Mimi
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

