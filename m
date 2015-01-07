Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbbAGB2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 20:28:10 -0500
Received: from dub004-omc3s27.hotmail.com ([157.55.2.36]:58153 "EHLO
	DUB004-OMC3S27.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751862AbbAGB2F convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:28:05 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jan 2015 20:28:05 EST
X-TMN: [/Zdt48ydqWGioTq/aBNwKY95RUYCk7Wl]
X-Originating-Email: [luky-37@hotmail.com]
Message-ID: <DUB123-W1008C526C7E0FA115A87EED460@phx.gbl>
From: Lukas Tribus <luky-37@hotmail.com>
To: Erik Grinaker <erik@bengler.no>, Eric Dumazet <eric.dumazet@gmail.com>
CC: Yuchung Cheng <ycheng@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: RE: TCP connection issues against Amazon S3
Date: Wed, 7 Jan 2015 02:23:00 +0100
Importance: Normal
In-Reply-To: <3F608393-E5F1-4647-81BF-C6C740100934@bengler.no>
References: <5DCDADEF-FF9C-4844-8A2C-62E2D3B3B8CE@bengler.no>
 <1420560253.32621.20.camel@edumazet-glaptop2.roam.corp.google.com>
 <D5C36777-4461-4B8D-B6C4-38B4276F42DC@bengler.no>
 <1420564837.32621.30.camel@edumazet-glaptop2.roam.corp.google.com>
 <8C4F7938-DCA1-46F5-A3C9-7DF62511DEE7@bengler.no>
 <CAK6E8=d5Z0W5sSAdeEcecKbqjj_UwGw4949=a20fetFpLVKwwA@mail.gmail.com>
 <03FC652E-AA01-42C7-BD52-019B6D922A9C@bengler.no>
 <CAK6E8=cP0BFUob5MVj9M0hC0efgRnUY=JMUPKee+v-4TLvHBgg@mail.gmail.com>
 <76DC89D1-CFCE-44B7-994E-4349FEEDEFA6@bengler.no>
 <1420575216.5947.12.camel@edumazet-glaptop2.roam.corp.google.com>
 <4DA8529D-4EEC-42DA-89B0-DC7746DB2B10@bengler.no>,<3F608393-E5F1-4647-81BF-C6C740100934@bengler.no>
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 07 Jan 2015 01:23:00.0854 (UTC) FILETIME=[7A060160:01D02A18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This still doesn’t explain why it works with older kernels, but not newer ones.

Can you try the different 3.12-rc kernels? The information that this was
introduced in 3.12-rc1 as opposed to a specific -rc>1 releases may help
the guys here to pinpoint what exactly caused the behavior change on the
receiver side.

v3.12-rc1 to -rc7 is available as prebuild package on the ubuntu mainline kernel
archive [1] aswell.


-Lukas


[1] http://kernel.ubuntu.com/~kernel-ppa/mainline/

 		 	   		  