Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbaE2Hzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:55:46 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:39423 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055AbaE2Hzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:55:44 -0400
Date: Thu, 29 May 2014 09:55:39 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jon Maxwell <jmaxwell37@gmail.com>
Cc: stephen@networkplumber.org, davem@davemloft.net,
        makita.toshiaki@lab.ntt.co.jp, vyasevic@redhat.com,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpirko@redhat.com, jmaxwell@redhat.com
Subject: Re: [PATCH net] bridge: notify user space after fdb update
Message-ID: <20140529075539.GD2942@minipsycho.orion>
References: <1401348436-5187-1-git-send-email-jmaxwell37@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401348436-5187-1-git-send-email-jmaxwell37@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thu, May 29, 2014 at 09:27:16AM CEST, jmaxwell37@gmail.com wrote:
>There has been a number incidents recently where customers running KVM have
>reported that VM hosts on different Hypervisors are unreachable. Based on
>pcap traces we found that the bridge was broadcasting the ARP request out
>onto the network. However some NICs have an inbuilt switch which on occasions
>were broadcasting the VMs ARP request back through the physical NIC on the
>Hypervisor. This resulted in the bridge changing ports and incorrectly learning
>that the VMs mac address was external. As a result the ARP reply was directed
>back onto the external network and VM never updated it's ARP cache. This patch
>will notify the bridge command, after a fdb has been updated to identify such
>port toggling.
>
>Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>

Reviewed-by: Jiri Pirko <jiri@resnulli.us>

