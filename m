Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbaBJVNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 16:13:14 -0500
Received: from infra.glanzmann.de ([88.198.249.254]:35353 "EHLO
	infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbaBJVNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 16:13:12 -0500
Date: Mon, 10 Feb 2014 22:13:08 +0100
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: dev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] This extends tx_data and and iscsit_do_tx_data with the
 additional parameter flags and avoids sending multiple TCP packets in
 iscsit_fe_sendpage_sg
Message-ID: <20140210211308.GD19621@glanzmann.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	Eric Dumazet <eric.dumazet@gmail.com>, dev@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <1391879318.10160.108.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140208171531.GA23798@glanzmann.de>
 <1391886759.10160.114.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140209074027.GA8105@glanzmann.de>
 <20140209074227.GA8219@glanzmann.de>
 <1391949039.10160.129.camel@edumazet-glaptop2.roam.corp.google.com>
 <1392058718.17867.8.camel@haakon3.risingtidesystems.com>
 <20140210205634.GC19621@glanzmann.de>
 <1392066100.6615.55.camel@edumazet-glaptop2.roam.corp.google.com>
 <1392066574.6615.57.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392066574.6615.57.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eric,

> Also please make sure you have this patch :
> http://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=4a5ab4e224288403b0b4b6b8c4d339323150c312

I did not have this patch. I apply it, rerun and send you the pcap.

(node-62) [~/work/linux-2.6] wcat
http://git.kernel.org/cgit/linux/kernel/git/davem/net.git/patch/?id=4a5ab4e224288403b0b4b6b8c4d339323150c312 | patch -p1
patching file net/ipv4/tcp_input.c
patching file net/ipv4/tcp_output.c
Hunk #1 succeeded at 1987 (offset 10 lines).

Cheers,
        Thomas
