Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab3HMG2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:28:13 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:46254 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab3HMG2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:28:11 -0400
Date: Tue, 13 Aug 2013 08:28:03 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: David Shwatrz <dshwatrz@gmail.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, grant.likely@linaro.org,
        rob.herring@calxeda.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: question about netif_rx
Message-ID: <20130813062803.GA13239@electric-eye.fr.zoreil.com>
References: <alpine.DEB.2.02.1308111151210.2072@localhost6.localdomain6>
 <20130811155640.GA10070@electric-eye.fr.zoreil.com>
 <alpine.DEB.2.02.1308111811440.2072@localhost6.localdomain6>
 <20130813052036.GA11640@electric-eye.fr.zoreil.com>
 <CAJJAcoe+GpRYqHyu1xctRaUnPXf4CP8=PTt=svJzJFtBjfqxrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJJAcoe+GpRYqHyu1xctRaUnPXf4CP8=PTt=svJzJFtBjfqxrg@mail.gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Shwatrz <dshwatrz@gmail.com> :
[...]
> what is the current state of checksum offloading support has to do
> with it ? maybe you meant current state of NAPI support ?

netif_receive_skb vs napi_gro_receive choice.

-- 
Ueimor
