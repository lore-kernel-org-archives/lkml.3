Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbaENVLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:11:20 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:42681 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbaENVLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:11:16 -0400
Message-ID: <5373DBCF.1080503@ahsoftware.de>
Date: Wed, 14 May 2014 23:10:39 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jon Loeliger <jdl@jdl.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [RFC PATCH 2/9] dt: deps: dependency based device creation
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>	<1399913280-6915-3-git-send-email-holler@ahsoftware.de>	<20140514140534.897F8C4153D@trevor.secretlab.ca>	<53738261.4000000@ahsoftware.de> <20140514200645.15984C4095B@trevor.secretlab.ca>
In-Reply-To: <20140514200645.15984C4095B@trevor.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.05.2014 22:06, schrieb Grant Likely:
> On Wed, 14 May 2014 16:49:05 +0200, Alexander Holler <holler@ahsoftware.de> wrote:
>> Am 14.05.2014 16:05, schrieb Grant Likely:
>>> On Mon, 12 May 2014 18:47:53 +0200, Alexander Holler <holler@ahsoftware.de> wrote:

>> Hmm, I don't really care if that will be merged. I have no motivation to 
>> fight with Linux kernel maintainers and I don't know if I will spend the 
>> necessary time to do so.
> 
> The people you need to convince are Rob, Greg, and me, and you've got my
> attention. If I'm convinced, then I can probably convince Greg also.
> You've got an interesting approach, and I hope you won't give up on it.

Sorry, but that point of the view is already a problem. Why do I have to
convince you people?

To summarize:

Linux kernel maintainers

- don't like code they haven't written theirself,
- don't like code which doesn't look like they have written it theirself,
- don't like ideas they haven't had themself,
- do feel good in their closed group they have formed,
...

You see, I long have given up. The reason I still posted these patches
is just because I don't care anymore about Linux kernel maintainers at
all. I was prepared that I do that just for the fun of annoying some
Linux kernel maintainers. I've already decided some time ago that I just
will post my patches once to the LKML (so that other poor Linux kernel
users may find them) and will ignore Linux kernel maintainers.

Sorry, but I have a long and very unpleasant history in dealing with
Linux kernel maintainers, and they already have called me almost
anything like "ugly code writer", "frustrated" and such things more.

Fortunately I'm too old to care about such, that's why I still post
patches (besides that I like to solve problems and help other people). ;)

Regards,

Alexander Holler
