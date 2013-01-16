Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab3APVxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 16:53:06 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33445 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756323Ab3APVxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 16:53:04 -0500
X-Sasl-enc: iRnxLxEko6ac/jplRlFxg4HBMfqO1QWGUYwa894EP3aJ 1358373182
Message-ID: <50F7213F.50601@signal11.us>
Date: Wed, 16 Jan 2013 16:53:03 -0500
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony.cheneau@amnesiak.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH 2/2] 6lowpan: Handle uncompressed IPv6 packets over 6LoWPAN
References: <1358315037-10043-1-git-send-email-alan@signal11.us> <1358315037-10043-3-git-send-email-alan@signal11.us> <20130116.162214.444431638469568669.davem@davemloft.net>
In-Reply-To: <20130116.162214.444431638469568669.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 04:22 PM, David Miller wrote:
> From: Alan Ott <alan@signal11.us>
> Date: Wed, 16 Jan 2013 00:43:57 -0500
>
>> +		local_skb = skb_copy_expand(skb, NET_SKB_PAD - 1,
>> +						skb_tailroom(skb), GFP_ATOMIC);
> This is not indented properly.
>
> When a function call spans multiple lines, the second and subsequent
> lines should be indented to the column right after the openning
> parenthesis of the call itself, using a combination of TAB and
> SPC characters as needed.

Thanks David, I'll fix and re-submit.

Alan.

