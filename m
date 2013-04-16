Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab3DPNvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 09:51:38 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:45780 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757494Ab3DPNvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 09:51:37 -0400
Message-ID: <1366120293.4459.133.camel@edumazet-glaptop>
Subject: Re: Bonding driver has bad load balancing for forwarded traffic,
 3.7+
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Jay Vosburgh <fubar@us.ibm.com>, John Eaglesham <linux@8192.net>
Date: Tue, 16 Apr 2013 06:51:33 -0700
In-Reply-To: <516D1374.1070500@telenet.dn.ua>
References: <516C075E.30105@telenet.dn.ua>
	  <1366072679.4459.113.camel@edumazet-glaptop>
	 <1366081404.4459.127.camel@edumazet-glaptop>
	 <516D1374.1070500@telenet.dn.ua>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-16 at 12:01 +0300, Vitaly V. Bursov wrote:

> Testing under real load for almost 2 hours now, works as expected.
> xmit_hash_policy=layer3+4
> 
> I made a few simple test with layer2+3 policy too, looks OK.
> 
> Thanks!

Perfect, thanks a lot for all this !

Tested-by: Vitaly V. Bursov <vitalyb@telenet.dn.ua>



