Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab3CSNwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 09:52:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323Ab3CSNwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 09:52:42 -0400
Message-ID: <51486D9D.3080909@redhat.com>
Date: Tue, 19 Mar 2013 14:52:29 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Jason Wang <jasowang@redhat.com>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        edumazet@google.com
Subject: Re: [PATCH net-next 2/2] net: reset transport header if it was not
 set before transmission
References: <1363333305-54398-1-git-send-email-jasowang@redhat.com>   <1363333305-54398-2-git-send-email-jasowang@redhat.com>   <1363399851.29475.52.camel@edumazet-glaptop>   <20130317.121318.1869489921021513474.davem@davemloft.net>   <51482F55.8020900@redhat.com> <1363695234.21184.36.camel@edumazet-glaptop>  <514860DC.9020404@redhat.com> <1363697998.21184.54.camel@edumazet-glaptop>
In-Reply-To: <1363697998.21184.54.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 01:59 PM, Eric Dumazet wrote:
> On Tue, 2013-03-19 at 13:58 +0100, Daniel Borkmann wrote:
>
>> Yes, will post them in a couple of minutes.
>
> Please target net tree for the first patch (adding thoff into struct
> flow_keys), so that Jason or me can fix DODGY  providers.

Sorry, I received this too late. The patch set is already out, but we
can put a note into the ``[PATCH net-next 1/4] flow_keys: include thoff
into flow_keys for later'' thread to let Dave know.
