Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaDULV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 07:21:29 -0400
Received: from dub0-omc3-s21.dub0.hotmail.com ([157.55.2.30]:37473 "EHLO
	dub0-omc3-s21.dub0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750906AbaDULV1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 07:21:27 -0400
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Apr 2014 07:21:27 EDT
X-TMN: [nVglOCvDnSvB7NMHVkMpnsXoCZ2r8+ar]
X-Originating-Email: [luky-37@hotmail.com]
Message-ID: <DUB123-W22F9256949F24CA9BB0890ED5E0@phx.gbl>
From: Lukas Tribus <luky-37@hotmail.com>
To: =?iso-8859-1?B?T3J0d2luIEds/GNr?= <odi@odi.ch>,
        Eric Dumazet <eric.dumazet@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "gerben@daybyday.nl" <gerben@daybyday.nl>,
        Vlad Yasevich <vyasevic@redhat.com>
Subject: RE: 3.14 regression: huge latency in read/select on tun
Date: Mon, 21 Apr 2014 13:13:35 +0200
Importance: Normal
In-Reply-To: <5354D997.70604@odi.ch>
References: <533C381E.9090103@odi.ch>
		 <1396456973.3989.41.camel@edumazet-glaptop2.roam.corp.google.com>
		 <533D133A.3090008@odi.ch>
		 <1396531176.12330.6.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1396533026.12330.9.camel@edumazet-glaptop2.roam.corp.google.com>
	 <5352D8FF.6070305@odi.ch>
 <1398011495.19600.22.camel@edumazet-glaptop2.roam.corp.google.com>,<5354D997.70604@odi.ch>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 21 Apr 2014 11:13:35.0594 (UTC) FILETIME=[BCF57CA0:01CF5D52]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Hmm.. probably already solved by commit
>> 1e785f48d29a09b6cf96db7b49b6320dada332e1
>> ("net: Start with correct mac_len in skb_network_protocol")
>
> Indeed that fixes it. I have cherry picked that onto 3.14 and it works.
> That means 1e785f48 should be applied to stable 3.13.y and 3.14.y too.

Its already in davem's stable-queue:
http://patchwork.ozlabs.org/bundle/davem/stable/?state=*
http://patchwork.ozlabs.org/patch/339082/


Lukas

 		 	   		  