Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313Ab3CHJFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 04:05:38 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:51383 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab3CHJFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 04:05:30 -0500
Date: Fri, 8 Mar 2013 04:05:30 -0500 (EST)
From: CAI Qian <caiqian@redhat.com>
To: netdev@vger.kernel.org
Cc: Ivan Vecera <ivecera@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Message-ID: <1306201826.11289096.1362733530172.JavaMail.root@redhat.com>
Subject: be2net failed to initialize regression
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.13.149]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emulex CNA card failed to initialize using 3.8 and the latest upstream kernel,

[   87.479859] be2net 0000:04:00.0: POST timeout; stage=0xc911 
[   87.515978] be2net 0000:04:00.0: Emulex OneConnect initialization failed 
[   87.557130] be2net: probe of 0000:04:00.0 failed with error -1 

lspci output,

04:00.0 Ethernet controller: Emulex Corporation OneConnect 10Gb NIC (rev 02)
04:00.1 Ethernet controller: Emulex Corporation OneConnect 10Gb NIC (rev 02)

04:00.1 Ethernet controller: Emulex Corporation OneConnect 10Gb NIC (rev 02)
        Subsystem: Hewlett-Packard Company NC551i Dual Port FlexFabric 10Gb Adapter

Confirmed no such problem using 3.7 kernel. Reproduced every time and still
bisecting. Just want to give an early head-up to see if anyone saw sometime
obvious.

CAI Qian
