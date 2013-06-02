Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab3FBJCh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 05:02:37 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:63834 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab3FBJCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 05:02:33 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5kzFuKr9
X-RZG-CLASS-ID: mo00
Message-ID: <51AB0A26.6070608@hartkopp.net>
Date: Sun, 02 Jun 2013 11:02:30 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130519 Icedove/17.0.5
MIME-Version: 1.0
To: thomas@m3y3r.de
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netdev: Cocci spatch "ptr_ret.spatch"
References: <1370080751.29224.37.camel@localhost.localdomain> <20130601.193717.2203825358470502762.davem@davemloft.net>
In-Reply-To: <20130601.193717.2203825358470502762.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

additionally to provide a proper log message it is a usual to provide the
coccinelle expression that found the source to be changed.

http://lwn.net/Articles/315686/


E.g. like these

http://marc.info/?l=linux-netdev&m=135081679626023&w=2
http://marc.info/?l=linux-netdev&m=135194048501621&w=2

http://marc.info/?l=linux-netdev&m=135306967411758&w=2
http://marc.info/?l=linux-netdev&m=135304902302198&w=2


Regards,
Oliver

On 02.06.2013 04:37, David Miller wrote:
> From: Thomas Meyer <thomas@m3y3r.de>
> Date: Sat, 01 Jun 2013 11:59:11 +0200
> 
>>
>> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> 
> This obscure reference to the cocci path you used to find/fix
> this problem is insufficient in detail for a commit log message.
> 
> You must explain exactly what the problem is, and how you fixed
> it, in full sentences.   You must make your commit header lin
> subject more appropriate as well.
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

