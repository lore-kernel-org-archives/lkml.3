Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbaGUGJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 02:09:32 -0400
Received: from mailsec108.isp.belgacom.be ([195.238.20.104]:36855 "EHLO
	mailsec108.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753104AbaGUGJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 02:09:29 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=UGN7JNw3bPEHpwjh5ACRRBK85/3fvewMg9DN/Z6sboU= c=1 sm=2
 a=HX2_gNi5fukA:10 a=IkcTkHD0fZMA:10 a=J1Y8HTJGAAAA:8
 a=wSDVx7dZsnTDSuh5xTIA:9 a=QEXdDO2ut3YA:10 a=4N9Db7Z2_RYA:10
 a=Z9-LGjJt_zwA:10 a=-LXDOyxUB2UA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgMHAF+tzFPD7hTU/2dsb2JhbABZgw6BKYJ4qysBAQEBAQEGnjYBgRIWdoQDAQEEASNWBQsFBg4GAQMCAhgOAgJXBhMRiCkMqCOGf49wF4EshE+JUAeCeIFOBY5DoRGDRjsv
Date: Mon, 21 Jul 2014 08:09:27 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: David Miller <davem@davemloft.net>
Cc: linuxppc-dev@lists.ozlabs.org, linux-wireless@vger.kernel.org,
        joe@perches.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, brcm80211-dev-list@broadcom.com
Message-ID: <1973473442.929183.1405922967308.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <20140720.213102.1007291311502673484.davem@davemloft.net>
References: <1405865801-18806-1-git-send-email-fabf@skynet.be> <20140720.213102.1007291311502673484.davem@davemloft.net>
Subject: Re: [PATCH 00/30] drivers/net: remove unnecessary break after
 return
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 21 July 2014 at 06:31 David Miller <davem@davemloft.net> wrote:
>
>
> From: Fabian Frederick <fabf@skynet.be>
> Date: Sun, 20 Jul 2014 16:16:08 +0200
>
> > Second patchset after "remove unnecessary break after goto" addressing break
> > redundancy on drivers/net branch
> > (suggested by Joe Perches)
>
> All applied except the i40e patch, which did not apply to net-next at all.

Thanks a lot David.

Fabian
