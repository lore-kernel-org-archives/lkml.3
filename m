Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab3ATPRH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 10:17:07 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:41452 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab3ATPRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 10:17:05 -0500
Message-ID: <50FC0A6C.205@gmail.com>
Date: Sun, 20 Jan 2013 16:17:00 +0100
From: Stephan Gatzka <stephan.gatzka@gmail.com>
Reply-To: stephan.gatzka@gmail.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire net: Ensure checksumming in upper layer.
References: <50FBA02C.9030203@linux-ipv6.org> <20130120105058.1aee26c4@stein> <50FBC8D5.50205@linux-ipv6.org> <50FC0353.8090902@gmail.com> <50FC08E5.6020903@linux-ipv6.org>
In-Reply-To: <50FC08E5.6020903@linux-ipv6.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> "Off-link source" means the source exists on the different L2
> network.  In other words, source is connected via router(s).
>
>           ethernet             firewire
>   Host -------------- Router ------------ Host
>

O.k., understood. But the receiving router verifies the checksum of 
incoming packets and sends them on the firewire link. On firewire we 
have CRC checksums to ensure the integrity of packets.

I agree with your patch but I don't see why we should check them in the 
driver. I thought your patch will ensure that the checksums will be 
verified in the upper layers.

Stephan
