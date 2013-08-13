Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab3HMFpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 01:45:24 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62719 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab3HMFpW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 01:45:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130813052036.GA11640@electric-eye.fr.zoreil.com>
References: <alpine.DEB.2.02.1308111151210.2072@localhost6.localdomain6>
	<20130811155640.GA10070@electric-eye.fr.zoreil.com>
	<alpine.DEB.2.02.1308111811440.2072@localhost6.localdomain6>
	<20130813052036.GA11640@electric-eye.fr.zoreil.com>
Date: Tue, 13 Aug 2013 08:45:21 +0300
Message-ID: <CAJJAcoe+GpRYqHyu1xctRaUnPXf4CP8=PTt=svJzJFtBjfqxrg@mail.gmail.com>
Subject: Re: question about netif_rx
From: David Shwatrz <dshwatrz@gmail.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, grant.likely@linaro.org,
        rob.herring@calxeda.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
what is the current state of checksum offloading support has to do
with it ? maybe you meant current state of NAPI support ?

regards,
DS

On Tue, Aug 13, 2013 at 8:20 AM, Francois Romieu <romieu@fr.zoreil.com> wrote:
> Julia Lawall <julia.lawall@lip6.fr> :
>> François Romieu <romieu@fr.zoreil.com> :
> [...]
>> > Can you send a netif_receive_skb replacement patch for it ?
>>
>> Just to be sure, I just replace netif_rx by netif_receive_skb, nothing
>> else?
>
> Yes. It should imho be fine with a comment incluing your analysis and a
> few words about the current state of checksum offloading support.
>
> --
> Ueimor
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
