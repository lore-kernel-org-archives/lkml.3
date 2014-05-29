Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934349AbaE2JPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 05:15:35 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:48231 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590AbaE2JPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 05:15:33 -0400
Message-ID: <5386FAA6.8030103@lab.ntt.co.jp>
Date: Thu, 29 May 2014 18:15:18 +0900
From: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jon Maxwell <jmaxwell37@gmail.com>, stephen@networkplumber.org
CC: davem@davemloft.net, vyasevic@redhat.com,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpirko@redhat.com, jmaxwell@redhat.com
Subject: Re: [PATCH net] bridge: notify user space after fdb update
References: <1401348436-5187-1-git-send-email-jmaxwell37@gmail.com>
In-Reply-To: <1401348436-5187-1-git-send-email-jmaxwell37@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/05/29 16:27), Jon Maxwell wrote:
> There has been a number incidents recently where customers running KVM have
> reported that VM hosts on different Hypervisors are unreachable. Based on
> pcap traces we found that the bridge was broadcasting the ARP request out
> onto the network. However some NICs have an inbuilt switch which on occasions
> were broadcasting the VMs ARP request back through the physical NIC on the
> Hypervisor. This resulted in the bridge changing ports and incorrectly learning
> that the VMs mac address was external. As a result the ARP reply was directed
> back onto the external network and VM never updated it's ARP cache. This patch
> will notify the bridge command, after a fdb has been updated to identify such
> port toggling.
> 
> Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>

Acked-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
