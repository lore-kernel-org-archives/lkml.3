Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab3ATOqt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 09:46:49 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:44849 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab3ATOqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 09:46:47 -0500
Message-ID: <50FC0353.8090902@gmail.com>
Date: Sun, 20 Jan 2013 15:46:43 +0100
From: Stephan Gatzka <stephan.gatzka@gmail.com>
Reply-To: stephan.gatzka@gmail.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire net: Ensure checksumming in upper layer.
References: <50FBA02C.9030203@linux-ipv6.org> <20130120105058.1aee26c4@stein> <50FBC8D5.50205@linux-ipv6.org>
In-Reply-To: <50FBC8D5.50205@linux-ipv6.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Indeed neither the device nor the lower drivers check protocol checksums.
>> But the CRCs of the encapsulating 1394 packets are checked in hardware.
>> Shall protocol checksums be verified regardless?
>
> Yes, because packets may come from off-link source.
>

Hm, I can't see any off-link packets coming from 
fwnet_finish_incoming_packet()

So I wont verify checksums in the driver.

Stephan
