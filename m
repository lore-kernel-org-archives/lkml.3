Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbaFWICu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:02:50 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:39456 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbaFWICq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:02:46 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfssBY9SQMKk8kCovkkmJbh+VP2spQG3tvMeGW7W
X-RZG-CLASS-ID: mo00
Date: Mon, 23 Jun 2014 10:02:42 +0200
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
Message-ID: <20140623080242.GA16924@aepfle.de>
References: <1403228076-7596-1-git-send-email-haiyangz@microsoft.com>
 <20140620045704.GA4850@aepfle.de>
 <20140620051213.GA9960@kroah.com>
 <ff458d1b896d4a70a32fa7709911274c@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ff458d1b896d4a70a32fa7709911274c@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, Haiyang Zhang wrote:

> This command ("/etc/init.d/network restart") exists on our supported distros
> currently. We will also look into some better ways to refresh the network for
> the distros without this command. I have tried setting IF_OPER_DORMANT then 
> IF_OPER_UP, but not working. I will look into the suspend/resume cycle as
> well.

I think its reasonable to expect guest config changes on this new kind
of host. Would a link-down/link-up event work? I'm sure it will, there
is enough code floating around in the guests which handles cable unplug. 

Olaf
