Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257Ab3LKJdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 04:33:12 -0500
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:58421 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab3LKJdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 04:33:09 -0500
Message-ID: <1386754347.16638.0.camel@localhost.localdomain>
Subject: Re: [PATCH v3] net: handle error more gracefully in socketpair()
From: Yann Droneaud <ydroneaud@opteya.com>
To: David Miller <davem@davemloft.net>
Cc: viro@ZenIV.linux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ydroneaud@opteya.com
Date: Wed, 11 Dec 2013 10:32:27 +0100
In-Reply-To: <20131210.222429.1538443980618684288.davem@davemloft.net>
References: <20131206104805.GM10323@ZenIV.linux.org.uk>
	 <20131206.121411.2205219888474731457.davem@davemloft.net>
	 <1386625340-8490-1-git-send-email-ydroneaud@opteya.com>
	 <20131210.222429.1538443980618684288.davem@davemloft.net>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 10 décembre 2013 à 22:24 -0500, David Miller a écrit :
> From: Yann Droneaud <ydroneaud@opteya.com>
> Date: Mon,  9 Dec 2013 22:42:20 +0100
> 
...
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> > Link: http://marc.info/?i=1385979146-13825-1-git-send-email-ydroneaud@opteya.com
> 
> Applied to net-next, thanks.

Thanks you.

Regards.

-- 
Yann Droneaud
OPTEYA


