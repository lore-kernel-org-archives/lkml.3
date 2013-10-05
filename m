Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab3JEK5f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 06:57:35 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49542 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab3JEK5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 06:57:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQV_aDmUqGO7HyybwH5fMYqjVpimKF7YA=Jp4EDSFzbQDA@mail.gmail.com>
References: <20131004011806.GE20450@dangermouse.emea.sgi.com>
	<CAErSpo6aE-vxhOHk_mgyWMYrgkG0Juuy8Bs-S2Hjb_7k8S=n8Q@mail.gmail.com>
	<CAE9FiQV_aDmUqGO7HyybwH5fMYqjVpimKF7YA=Jp4EDSFzbQDA@mail.gmail.com>
Date: Sat, 5 Oct 2013 18:57:32 +0800
Message-ID: <CABawtvPL3ECq=QLVxDNtmgjWWV2B6+Z=5S+wJ9VXwT0jRsxh8w@mail.gmail.com>
Subject: Re: Commit 07f9b61 breaks systems that don't implement a _CBA method
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ethan Zhao <ethan.zhao@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 5, 2013 at 7:55 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Oct 4, 2013 at 3:11 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Thu, Oct 3, 2013 at 7:18 PM, Hedi Berriche <hedi@sgi.com> wrote:
>
>> It's regrettable that the code is so subtle.  The obvious thing to do
>> would be to check for _CBA, and if it doesn't exist, look for an MCFG
>> entry.  But for various historical reasons, the code is a mess, and we
>> haven't figured out how to safely simplify it.
>>
>> Ethan, Yinghai, any objections to reverting 07f9b61?
>
> yes, that is right solution.
> --
Thanks, pull it out from the trap.

> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
