Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760262Ab3DCHuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 03:50:06 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:35280 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753561Ab3DCHuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 03:50:05 -0400
Message-ID: <515BDF23.9000508@gaisler.com>
Date: Wed, 03 Apr 2013 09:49:55 +0200
From: Andreas Larson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
CC: Anton Vorontsov <anton@enomsg.org>, Rob Herring <rob.herring@calxeda.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        software@gaisler.com
Subject: Re: [PATCH v5 1/3] gpio: gpio-generic: Add 16 and 32 bit big endian
 byte order support
References: <1363355140-28216-1-git-send-email-andreas@gaisler.com> <1363355140-28216-2-git-send-email-andreas@gaisler.com> <20130319004012.GA1004@lizard.gateway.2wire.net> <CACRpkdY6D3hvBm13Y41NTbnAav03guB7LEB4RHnRanFXjj_UJw@mail.gmail.com>
In-Reply-To: <CACRpkdY6D3hvBm13Y41NTbnAav03guB7LEB4RHnRanFXjj_UJw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-03-27 09:58, Linus Walleij wrote:
> On Tue, Mar 19, 2013 at 1:40 AM, Anton Vorontsov <anton@enomsg.org> wrote:
>> On Fri, Mar 15, 2013 at 02:45:38PM +0100, Andreas Larsson wrote:
>>> There is no general support for 64-bit big endian accesses, so that is
>>> left unsupported.
>>>
>>> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
>>
>> This looks perfect, thanks a lot!
>>
>> Acked-by: Anton Vorontsov <anton@enomsg.org>
>
> Looks good to me as well, but since this was discussed with Grant
> I want his review on this before I merge it.

I take it that you are happy with the other two patches as well?

Grant, any chance of getting this into the 3.10 merge window?

Cheers,
Andreas Larsson

