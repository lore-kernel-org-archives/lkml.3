Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab3C0I64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:58:56 -0400
Received: from mail-ia0-f176.google.com ([209.85.210.176]:58191 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab3C0I6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:58:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130319004012.GA1004@lizard.gateway.2wire.net>
References: <1363355140-28216-1-git-send-email-andreas@gaisler.com>
	<1363355140-28216-2-git-send-email-andreas@gaisler.com>
	<20130319004012.GA1004@lizard.gateway.2wire.net>
Date: Wed, 27 Mar 2013 09:58:48 +0100
Message-ID: <CACRpkdY6D3hvBm13Y41NTbnAav03guB7LEB4RHnRanFXjj_UJw@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] gpio: gpio-generic: Add 16 and 32 bit big endian
 byte order support
From: Linus Walleij <linus.walleij@linaro.org>
To: Anton Vorontsov <anton@enomsg.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Andreas Larsson <andreas@gaisler.com>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, software@gaisler.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 1:40 AM, Anton Vorontsov <anton@enomsg.org> wrote:
> On Fri, Mar 15, 2013 at 02:45:38PM +0100, Andreas Larsson wrote:
>> There is no general support for 64-bit big endian accesses, so that is
>> left unsupported.
>>
>> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
>
> This looks perfect, thanks a lot!
>
> Acked-by: Anton Vorontsov <anton@enomsg.org>

Looks good to me as well, but since this was discussed with Grant
I want his review on this before I merge it.

Yours,
Linus Walleij
