Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab3KDOr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 09:47:56 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:60935 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab3KDOrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 09:47:55 -0500
Message-ID: <5277B399.8050809@gmail.com>
Date: Mon, 04 Nov 2013 08:47:53 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rostislav Lisovy <lisovy@gmail.com>,
        Silvio F <silvio.fricke@gmail.com>
Subject: Re: linux-next: manual merge of the dt-rh tree with the imx-mxs tree
References: <20131104152739.92ae486e7d418221c6a48a1e@canb.auug.org.au> <20131104131739.GC24970@S2101-09.ap.freescale.net> <5277AC16.3060000@gmail.com> <20131104143616.GD24970@S2101-09.ap.freescale.net>
In-Reply-To: <20131104143616.GD24970@S2101-09.ap.freescale.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2013 08:36 AM, Shawn Guo wrote:
> On Mon, Nov 04, 2013 at 08:15:50AM -0600, Rob Herring wrote:
>> On 11/04/2013 07:17 AM, Shawn Guo wrote:
>>> On Mon, Nov 04, 2013 at 03:27:39PM +1100, Stephen Rothwell wrote:
>>>> Hi Rob,
>>>>
>>>> Today's linux-next merge of the dt-rh tree got a conflict in
>>>> Documentation/devicetree/bindings/vendor-prefixes.txt between commit
>>>> 064d7f6c985a ("ARM: dts: Add vendor prefix for Voipac Technologies
>>>> s.r.o") from the imx-mxs tree and commit d6c3073e7fb5 ("DT: sort
>>>> vendor-prefixes.txt") from the dt-rh tree.
>>>
>>> Hi Rob,
>>>
>>> Would you like to apply the patch "ARM: dts: Add vendor prefix for
>>> Voipac Technologies s.r.o" on your tree, so that we can save this
>>> conflict?  If so, I will drop the patch from my tree.  Just let me know.
>>
>> Unless it is the top commit, it is best to not rebase your tree.
> 
> I'm queuing the patch for 3.14, and my branch will be rebased to
> 3.13-rc anyway.
> 
> Are you queuing "DT: sort vendor-prefixes.txt" for 3.13 or 3.14?  If
> it's for 3.13, we will be fine, since the conflict will be solved on my
> side when my branch gets rebased to 3.13-rc.

It is for 3.13.

Rob

