Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965197Ab3DJS1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 14:27:34 -0400
Received: from mail-ia0-f178.google.com ([209.85.210.178]:42238 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964862Ab3DJS1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 14:27:33 -0400
MIME-Version: 1.0
In-Reply-To: <515BDF23.9000508@gaisler.com>
References: <1363355140-28216-1-git-send-email-andreas@gaisler.com>
	<1363355140-28216-2-git-send-email-andreas@gaisler.com>
	<20130319004012.GA1004@lizard.gateway.2wire.net>
	<CACRpkdY6D3hvBm13Y41NTbnAav03guB7LEB4RHnRanFXjj_UJw@mail.gmail.com>
	<515BDF23.9000508@gaisler.com>
Date: Wed, 10 Apr 2013 20:27:32 +0200
Message-ID: <CACRpkdaPGFH9k3ePHpXfKxyowoXMrbnbAgP5qb32CG2NANs8Pw@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] gpio: gpio-generic: Add 16 and 32 bit big endian
 byte order support
From: Linus Walleij <linus.walleij@linaro.org>
To: Andreas Larson <andreas@gaisler.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Anton Vorontsov <anton@enomsg.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        software@gaisler.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 3, 2013 at 9:49 AM, Andreas Larson <andreas@gaisler.com> wrote:
> On 2013-03-27 09:58, Linus Walleij wrote:
>>
>> On Tue, Mar 19, 2013 at 1:40 AM, Anton Vorontsov <anton@enomsg.org> wrote:
>>>
>>> On Fri, Mar 15, 2013 at 02:45:38PM +0100, Andreas Larsson wrote:
>>>>
>>>> There is no general support for 64-bit big endian accesses, so that is
>>>> left unsupported.
>>>>
>>>> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
>>>
>>>
>>> This looks perfect, thanks a lot!
>>>
>>> Acked-by: Anton Vorontsov <anton@enomsg.org>
>>
>>
>> Looks good to me as well, but since this was discussed with Grant
>> I want his review on this before I merge it.
>
>
> I take it that you are happy with the other two patches as well?
>
> Grant, any chance of getting this into the 3.10 merge window?

Apparently Grant is busy these days, so I took a review of the
patch and I like it. With Anton's ACK as well I'm certain it's good,
so patch applied!

Yours,
Linus Walleij
