Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab3GYUQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 16:16:18 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:50355 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab3GYUQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 16:16:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130725193135.GT23879@titan.lakedaemon.net>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
	<CAL_JsqJQWOLC9f1igEpsgJB2X8mFDpqLDaFFRjGGVHctjWZLgQ@mail.gmail.com>
	<20130725193135.GT23879@titan.lakedaemon.net>
Date: Thu, 25 Jul 2013 15:16:14 -0500
Message-ID: <CAL_Jsq+vWbTb8wNEDCR2c_M6sBnKW6e5HGk48QzmXSujQUdddA@mail.gmail.com>
Subject: Re: DT bindings as ABI [was: Do we have people interested in device
 tree janitoring / cleanup?]
From: Rob Herring <robherring2@gmail.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 2:31 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> On Thu, Jul 25, 2013 at 02:11:31PM -0500, Rob Herring wrote:
>> On Thu, Jul 25, 2013 at 11:09 AM, Olof Johansson <olof@lixom.net> wrote:
>
>> > One problem that needs to be solved is obviously how a binding
>> > graduates from tentative to locked. This work isn't going to be very
>> > interesting to most people, I suspect. Think standards committee type
>> > work.
>>
>> I think a time based stabilization period would be better than a
>> separate directory to apply bindings too. Or time plus periodic review
>> perhaps.
>
> The only problem with a time-based versus separate directory is how do
> users who've downloaded the tree determine which bindings are stable?
> If they pull a tarball, or receive an SDK, there is most likely no git
> history attached.

Well, if time based includes moving the binding out of the kernel,
then that is what defines it as stable or not. I guess that is a form
of a separate directory. I don't think we want to be moving bindings
twice: tentative -> stable and kernel -> DT repo.

The policy could be as simple as an binding without change in at least
N kernel releases is moved out and stable.

Rob
