Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750973AbaEQTAv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 15:00:51 -0400
Received: from vms173025pub.verizon.net ([206.46.173.25]:48597 "EHLO
	vms173025pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaEQTAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 15:00:50 -0400
X-Greylist: delayed 3603 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 May 2014 15:00:50 EDT
Date: Sat, 17 May 2014 14:00:42 -0400
From: "Amadeus W.M." <amadeus84@verizon.net>
To: linux-kernel@vger.kernel.org
Subject: i8042 error
Message-id: <20140517140042.51531461@alpha>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have this old dell inspiron 2600 laptop with dual boot XP and Fedora
12 running some version of the 2.6 kernel and the keyboard and the
mousepad are dead in linux. When I boot linux I get this error message:

Can't read CTR while initializing i8042

which is in i8042.c. Past that point, I can't interact with the laptop
in any way. 

The keyboard and mouse work fine in linux in the past and work now in XP
so it's not (entirely) a hardware problem. I have not used the laptop
in a while so I don't know if it ever worked in F12 but I was obviously
able to install it. Now if I try to install the latest Fedora 20 with
the 3.6 kernel I have the exact problem upon install. 

I did do a memory upgrade which involved some work under the keyboard,
and that may have something to do with this problem, but - again - it
works in XP. 

Is there any hope? I'll provide any info necessary if someone can help,
although not sure what I can do if I can't type anything.

I'm not subscribed to the list, so please CC me when necessary.
