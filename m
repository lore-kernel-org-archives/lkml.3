Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab3CUIRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 04:17:07 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:38900 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab3CUIRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 04:17:02 -0400
MIME-Version: 1.0
In-Reply-To: <1363851836.17680.20.camel@pasglop>
References: <1363791074-16415-1-git-send-email-grant.likely@secretlab.ca>
 <1363791074-16415-3-git-send-email-grant.likely@secretlab.ca>
 <1363791479.12701.9.camel@pasglop> <CACxGe6u2wNbPQSOPRCRO0To5UC-b8rXYanv2xv26hk5oaozvPA@mail.gmail.com>
 <1363839594.17680.19.camel@pasglop> <CACxGe6sXcg51VhFujsjCsMzF80pdy_QhAposdmya4-C0eEcuUw@mail.gmail.com>
 <1363851836.17680.20.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 21 Mar 2013 08:16:41 +0000
X-Google-Sender-Auth: OSs8GpyEqzcrBIOx_Y6HG3z7sMc
Message-ID: <CACxGe6thdnQo6sPDccEGzUEkXFDGRD4aq_DJOop6Cincb94ODA@mail.gmail.com>
Subject: Re: [PATCH 2/2] of: remove /proc/device-tree
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 7:43 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Thu, 2013-03-21 at 07:35 +0000, Grant Likely wrote:
>> > Shouldn't we have the symlink just be a config option itself ?
>> > Eventually distros might want get rid of it completely ..
>>
>> Why? It is the cheapest thing in the world and it means the ABI
>> doesn't change at all.
>
> It's also gross and forces sysfs to remain in /sys which isn't a kernel
> enforced policy afaik.

Documentation/sysfs-rules.txt, Line 30

g.
