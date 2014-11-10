Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaKJOG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:06:59 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:47535 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbaKJOG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:06:57 -0500
MIME-Version: 1.0
In-Reply-To: <1415596626.5769.14.camel@kernel.crashing.org>
References: <1415342031.4925.27.camel@kernel.crashing.org> <1415342117.4925.29.camel@kernel.crashing.org>
 <1415596626.5769.14.camel@kernel.crashing.org>
From: Rob Herring <robherring2@gmail.com>
Date: Mon, 10 Nov 2014 08:06:35 -0600
Message-ID: <CAL_JsqKG=vpeGKj3v-2VW9oGQsnmuYMHRfy6LuXDXE=ROjHT4w@mail.gmail.com>
Subject: Re: [RFC] Add of_path property for all devices with a node
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Grant.

On Sun, Nov 9, 2014 at 11:17 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Fri, 2014-11-07 at 17:35 +1100, Benjamin Herrenschmidt wrote:
>> On Fri, 2014-11-07 at 17:33 +1100, Benjamin Herrenschmidt wrote:
>>
>> > So I came up with this patch,
>>
>> And here is the actual patch, which might help :-) It's pretty trivial
>> and small...
>
> So not much reactions here .. a bit more on IRC, where Olof suggested
> that rather than a file containing a path, we could use a symlink since
> the devtree is now in sysfs, so we can do relative links.

+1 on this. That was part of the motivation to move DT into sysfs.

Rob

> That means keeping the legacy "devspec" files in the few places where
> they exist, possibly behind a deprecated-default-y config option (though
> we might never be able to deprecate them...), but there aren't many.
>
> Any preference either way ?
>
> Cheers,
> Ben.
>
>
