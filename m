Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab3KZRnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 12:43:32 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:35578 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab3KZRn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 12:43:26 -0500
Message-ID: <5294DDB8.8050207@gmail.com>
Date: Tue, 26 Nov 2013 11:43:20 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] checkpatch: add DT compatible string documentation check
References: <1385481675-26675-1-git-send-email-robherring2@gmail.com>	 <1385484225.20100.58.camel@joe-AO722>	 <CAL_JsqKgUQZT4g3fgPe-h8G-zWb1gnfxgT20BDrL+zS5u4URzg@mail.gmail.com> <1385486940.20100.60.camel@joe-AO722>
In-Reply-To: <1385486940.20100.60.camel@joe-AO722>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 11:29 AM, Joe Perches wrote:
> On Tue, 2013-11-26 at 11:11 -0600, Rob Herring wrote:
>> I think we don't really want '+' (or '_') in compatible strings.
> 
> What about lines like:
> arch/powerpc/boot/dts/kmeter1.dts:  compatible = "ucc_geth";

I didn't say we don't have them, but for new bindings we want to flag
things like this. It is fine if new dts files use those existing
bindings, but no one should be creating new bindings with the deprecated
style. The problem is that I can't really automate this check on the
binding documentation until we move to schema based bindings (which
won't be soon). So I would like to warn if dts files use deprecated
styles. I don't expect this to be a frequent occurrence.

Rob

