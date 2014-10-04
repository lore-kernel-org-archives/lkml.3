Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbaJDLd6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 07:33:58 -0400
Received: from ns207790.ip-94-23-215.eu ([94.23.215.26]:48777 "EHLO
	ns207790.ip-94-23-215.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaJDLd5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 07:33:57 -0400
X-Greylist: delayed 548 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Oct 2014 07:33:56 EDT
From: =?ISO-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>
To: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        netdev@vger.kernel.org
Subject: Re: [RFC 1/1] net: fix rcu access on phonet_routes
Date: Sat, 04 Oct 2014 14:24:47 +0300
Message-ID: <1511645.tJ3y45khDT@basile.remlab.net>
Organization: Remlab
User-Agent: KMail/4.14.1 (Linux/3.16.3-basile; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1412416676-21698-1-git-send-email-fabf@skynet.be>
References: <1412416676-21698-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 4 octobre 2014, 11:57:56 Fabian Frederick a écrit :
(snip)
> -Access table with rcu_dereference (fixes the following sparse errors):
> net/phonet/pn_dev.c:278:25: error: incompatible types in comparison
> expression (different address spaces) net/phonet/pn_dev.c:391:17: error:
> incompatible types in comparison expression (different address spaces)

Acked-by: Rémi Denis-Courmont <remi@remlab.net>

-- 
Rémi Denis-Courmont
http://www.remlab.net/

