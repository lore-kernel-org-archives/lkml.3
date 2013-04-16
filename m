Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964853Ab3DPOZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 10:25:22 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:62698 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933715Ab3DPOZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 10:25:20 -0400
Message-ID: <1366122317.4459.135.camel@edumazet-glaptop>
Subject: Re: Bonding driver has bad load balancing for forwarded traffic,
 3.7+
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Jay Vosburgh <fubar@us.ibm.com>, John Eaglesham <linux@8192.net>
Date: Tue, 16 Apr 2013 07:25:17 -0700
In-Reply-To: <1366120293.4459.133.camel@edumazet-glaptop>
References: <516C075E.30105@telenet.dn.ua>
	 <1366072679.4459.113.camel@edumazet-glaptop>
	 <1366081404.4459.127.camel@edumazet-glaptop>
	 <516D1374.1070500@telenet.dn.ua>
	 <1366120293.4459.133.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-16 at 06:51 -0700, Eric Dumazet wrote:

> Perfect, thanks a lot for all this !
> 
> Tested-by: Vitaly V. Bursov <vitalyb@telenet.dn.ua>
> 
> 

By the way, we probably should use skb_flow_dissect() to get proper
hashing for tunnels users.



