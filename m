Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab3CTViZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 17:38:25 -0400
Received: from mail-ia0-f178.google.com ([209.85.210.178]:40422 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab3CTViY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 17:38:24 -0400
MIME-Version: 1.0
In-Reply-To: <1363791479.12701.9.camel@pasglop>
References: <1363791074-16415-1-git-send-email-grant.likely@secretlab.ca>
 <1363791074-16415-3-git-send-email-grant.likely@secretlab.ca> <1363791479.12701.9.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 20 Mar 2013 21:38:03 +0000
X-Google-Sender-Auth: qpOfVFzKeMmzTf0Tw0xbOE7wp_c
Message-ID: <CACxGe6u2wNbPQSOPRCRO0To5UC-b8rXYanv2xv26hk5oaozvPA@mail.gmail.com>
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

On Wed, Mar 20, 2013 at 2:57 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Wed, 2013-03-20 at 14:51 +0000, Grant Likely wrote:
>> The same data is now available in sysfs, so we can remove the code
>> that exports it in /proc and replace it with a symlink to the sysfs
>> version.
>>
>> Tested on versatile qemu model and mpc5200 eval board. More testing
>> would be appreciated.
>
> NAK. It should at the very least be a CONFIG option for a while before
> completely switching over.

I'll modify patch 1 to create the symlink if CONFIG_PROC_DEVICETREE is
not set. After the first patch can be applied we can leave it for a
release or two before applying the second.

g.
