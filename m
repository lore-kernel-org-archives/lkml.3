Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab3CSJ1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:27:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022Ab3CSJ0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:26:55 -0400
Message-ID: <51482F55.8020900@redhat.com>
Date: Tue, 19 Mar 2013 17:26:45 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com, edumazet@google.com
Subject: Re: [PATCH net-next 2/2] net: reset transport header if it was not
 set before transmission
References: <1363333305-54398-1-git-send-email-jasowang@redhat.com> <1363333305-54398-2-git-send-email-jasowang@redhat.com> <1363399851.29475.52.camel@edumazet-glaptop> <20130317.121318.1869489921021513474.davem@davemloft.net>
In-Reply-To: <20130317.121318.1869489921021513474.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2013 12:13 AM, David Miller wrote:
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Fri, 15 Mar 2013 19:10:51 -0700
>
>> Any way we can avoid adding this to fast path, for people not using
>> macvtap and ixgbe ?
> Likewise I'd rather see macvtap be responsible for fixing this up by
> setting the transport header properly, and therfore sending well
> formed packets to the rest of the stack.

Ok, haven't checked all other possibility but looks like packet needs to
be fixed also.
