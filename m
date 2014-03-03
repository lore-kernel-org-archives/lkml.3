Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaCCFfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 00:35:17 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:53506 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaCCFfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 00:35:15 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <5314113E.1030106@wwwdotorg.org>
References: <20140303120241.11066f951d53c50fb14faf47@canb.auug.org.au>
	<5314113E.1030106@wwwdotorg.org>
Date: Sun, 2 Mar 2014 21:35:14 -0800
Message-ID: <CAOesGMjYtD3xmpLphWO4HV2=RdAN=JaSz5hRZFbsmTP721X+PQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the bcm2835 tree with the arm-soc tree
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Markus Mayer <markus.mayer@linaro.org>, Rob Herring <robh@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 2, 2014 at 9:21 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 03/02/2014 06:02 PM, Stephen Rothwell wrote:
>> Hi Stephen,
>>
>> Today's linux-next merge of the bcm2835 tree got a conflict in
>> arch/arm/mach-bcm2835/Kconfig between commits ddb902cc3459 ("ARM:
>> centralize common multi-platform kconfig options") and
>> 0676b21fffd1 ("ARM: bcm2835: enable V6K instead of plain V6") from
>> the arm-soc tree and commit d30fe6272183 ("ARM: bcm2835: Move to
>> mach-bcm directory") from the bcm2835 tree.
>
> Olof, Arnd, Kevin,
>
> Do you want me to rebase the patch that moves
> arch/arm/mach-bcm2835/Kconfig into arch/arm/mach-bcm/Kconfig, or even
> drop it and take it through arm-soc directly? Or, will you just handle
> this when you merge the pull request?

We should be fine handling it when we merge. Conflicts when we merge
in are just fine unless they are excessive, what we want to avoid for
most silly cases is when it'll be exposed all the way up to Linus.
Even then, some of them are ok since it's just how development works.


-Olof
