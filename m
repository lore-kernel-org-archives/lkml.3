Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbaENKMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 06:12:48 -0400
Received: from www.meduna.org ([92.240.244.38]:51428 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554AbaENKMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 06:12:46 -0400
Message-ID: <5373418F.6090602@meduna.org>
Date: Wed, 14 May 2014 12:12:31 +0200
From: Stanislav Meduna <stano@meduna.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>
Subject: Freescale FEC i.MX28 VLAN support?
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2014-05-14 12:12:35
X-Connected-IP: 95.105.163.217:7735
X-Message-Linecount: 32
X-Body-Linecount: 19
X-Message-Size: 1096
X-Body-Size: 542
X-Received-Count: 1
X-Recipient-Count: 3
X-Local-Recipient-Count: 3
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

is there any particular reason why the FEC_QUIRK_HAS_VLAN
is only set for imx6q-fec ?

According to the reference manual the VLAN support is also
present in i.MX28 and the DMA descriptors look the same
in this regard, but this is from eyeballing only, I did not
try to play with it yet.

The reason I am asking is that I am using a switch that can
tag the frames according to the port a packet is received
from/sent to and I would like to use that feature.

Please Cc: me when replying.

Thanks
-- 
                                Stano
