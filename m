Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbaFZIwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 04:52:09 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.162]:10693 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbaFZIwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 04:52:05 -0400
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jun 2014 04:52:05 EDT
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfssBY9SQMKk8kCovkkmJbh+VP2spQG3tvMeGW7W
X-RZG-CLASS-ID: mo00
Date: Thu, 26 Jun 2014 10:45:39 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Greg KH <greg@kroah.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next] hyperv: Add handler for
 RNDIS_STATUS_NETWORK_CHANGE event
Message-ID: <20140626084539.GA32471@aepfle.de>
References: <1403228076-7596-1-git-send-email-haiyangz@microsoft.com>
 <20140620045704.GA4850@aepfle.de>
 <20140620051213.GA9960@kroah.com>
 <ff458d1b896d4a70a32fa7709911274c@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140623080242.GA16924@aepfle.de>
 <06b508cbb6b949f4b3e13e7797948e56@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140623131723.GA7026@aepfle.de>
 <5fb9ddebb68d456ab87979b5cc3830ec@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140623162705.GA5957@aepfle.de>
 <4ee8be5360a44b5abfa6df871ec45527@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4ee8be5360a44b5abfa6df871ec45527@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, Haiyang Zhang wrote:

> Yes, there is a link down/up event from the host, we currently call netif_carrier_off() 
> / netif_carrier_on() with these events. Will hotplug scripts be triggered by 
> netif_carrier_off/on? Where are the scripts located at (SLES)?

In /etc/sysconfig/network/ifcfg-eth0 STARTMODE= should be set to
"ifplugd", this will most likely fix this sort of setup.

Olaf
