Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab3GVSZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:25:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49325 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875Ab3GVSZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:25:15 -0400
Message-ID: <51ED78EE.9020903@zytor.com>
Date: Mon, 22 Jul 2013 11:24:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Daniel Kiper <daniel.kiper@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Brandon Philips <brandon@ifup.org>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: is kexec on Xen domU possible?
References: <20130719020603.GA22932@kroah.com> <20130719131819.GC11233@debian70-amd64.local.net-space.pl> <20130719151243.GA15488@kroah.com> <20130719183235.GA12267@debian70-amd64.local.net-space.pl> <20130719191449.GA1882@kroah.com> <51E9A85D.2060206@zytor.com> <20130722170307.GB14451@debian70-amd64.local.net-space.pl> <87wqoise9d.fsf@xmission.com>
In-Reply-To: <87wqoise9d.fsf@xmission.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 10:20 AM, Eric W. Biederman wrote:
>>>
>>> Also, in any virtualized environment the hypervisor can do a better job
>>> for things like kdump, simply because it can provide two things that are
>>> otherwise hard to do:
>>>
>>> 1. a known-good system state;
>>> 2. a known-clean kdump image.
>>>
>>> As such, I do encourage the virtualization people to (also) develop
>>> hypervisor-*aware* solutions for these kinds of things.
>>
>> In general I agree but if you could not change hypervisor
>> and/or dom0 (e.g. you are using cloud providers which are
>> stick to old versions of Xen) then you have no choice.
> 
> Which tends to be where kexec on panic comes in most cases.  Getting
> platform vendors to do something sane tends to be a multi-year political
> effort of dubious worth while just solving the problem locally actually
> gets the problem solved for those who care.
> 

It should not be a "one or the other" issue.

	-hpa


