Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab3F0FMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 01:12:15 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:58681 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab3F0FMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 01:12:13 -0400
MIME-Version: 1.0
In-Reply-To: <CA+qZnSSPxO3h0v7An3R7e-HHs+bi4Ua-LE9coJtQL8CFWOHNBA@mail.gmail.com>
References: <CA+qZnSSj+UCV9LUddS8qArnG5e8Q4wyC98B=awJ9TBbY+J6nBw@mail.gmail.com>
	<CA+qZnSSPxO3h0v7An3R7e-HHs+bi4Ua-LE9coJtQL8CFWOHNBA@mail.gmail.com>
Date: Thu, 27 Jun 2013 13:12:13 +0800
Message-ID: <CA+qZnSTo_s3Y=hmfpJKxL0UaJ9nwWFgD4AFh356Kw8siHgh_Gg@mail.gmail.com>
Subject: Re:
From: tingwei liu <tingw.liu@gmail.com>
To: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Linus Torvalds <linus971@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi， dears

      I have found many RetransSegs of tcp by /proc/net/snmp, but I
can't capture these packet on local system by tcpdump.
      What could be the reason? Droped by qdisc level or device
driver? How to confirm that?

      I also find patch "[PATCH] tcp: reflect SYN queue_mapping into
SYNACK packets" provided by Eirc, how to confirm this?

 Thanks very much!
