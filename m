Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949AbaKRPSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:18:53 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:53736 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932865AbaKRPSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:18:50 -0500
MIME-Version: 1.0
In-Reply-To: <CAL_JsqKG=vpeGKj3v-2VW9oGQsnmuYMHRfy6LuXDXE=ROjHT4w@mail.gmail.com>
References: <1415342031.4925.27.camel@kernel.crashing.org> <1415342117.4925.29.camel@kernel.crashing.org>
 <1415596626.5769.14.camel@kernel.crashing.org> <CAL_JsqKG=vpeGKj3v-2VW9oGQsnmuYMHRfy6LuXDXE=ROjHT4w@mail.gmail.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Tue, 18 Nov 2014 15:18:29 +0000
X-Google-Sender-Auth: n-SpaRPY4tbkD7qZbtEWUg2HKtI
Message-ID: <CACxGe6vg8SxwCHZ8HxzLzimQOAf8Q81wd5eO=x2LavD4dv81Rw@mail.gmail.com>
Subject: Re: [RFC] Add of_path property for all devices with a node
To: Rob Herring <robherring2@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 2:06 PM, Rob Herring <robherring2@gmail.com> wrote:
> Adding Grant.
>
> On Sun, Nov 9, 2014 at 11:17 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
>> On Fri, 2014-11-07 at 17:35 +1100, Benjamin Herrenschmidt wrote:
>>> On Fri, 2014-11-07 at 17:33 +1100, Benjamin Herrenschmidt wrote:
>>>
>>> > So I came up with this patch,
>>>
>>> And here is the actual patch, which might help :-) It's pretty trivial
>>> and small...
>>
>> So not much reactions here .. a bit more on IRC, where Olof suggested
>> that rather than a file containing a path, we could use a symlink since
>> the devtree is now in sysfs, so we can do relative links.
>
> +1 on this. That was part of the motivation to move DT into sysfs.
>
> Rob

I had a patch that did exactly that. I wonder what happened to it...

But regardless, as Frank said in his reply, this data is already in
the uevent file for every device.

g.
