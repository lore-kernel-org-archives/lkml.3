Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab3BJH6D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 02:58:03 -0500
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:14198 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab3BJH6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 02:58:00 -0500
X-IronPort-AV: E=Sophos;i="4.84,636,1355126400"; 
   d="scan'208";a="21731722"
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: netdev <netdev@vger.kernel.org>, <linux-can@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <e1000-devel@lists.sourceforge.net>,
        <linux-usb@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <ath9k-devel@venema.h4ckr.net>, <wil6210@qca.qualcomm.com>,
        <brcm80211-dev-list@broadcom.com>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH] drivers: net: Remove remaining alloc/OOM messages
Date: Sun, 10 Feb 2013 09:57:54 +0200
Message-ID: <1877379.y4GS62BPgg@lx-vladimir>
Organization: Qualcomm Atheros
User-Agent: KMail/4.9.4 (Linux/3.5.0-23-generic; KDE/4.9.4; x86_64; ; )
In-Reply-To: <1360273587.27863.15.camel@joe-AO722>
References: <1360273587.27863.15.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 07, 2013 01:46:27 PM Joe Perches wrote:
> alloc failures already get standardized OOM
> messages and a dump_stack.
> 
> For the affected mallocs around these OOM messages:
> 
> Converted kmallocs with multiplies to kmalloc_array.
> Converted a kmalloc/memcpy to kmemdup.
> Removed now unused stack variables.
> Removed unnecessary parentheses.
> Neatened alignment.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 

For wil6210:

Acked--by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Thanks, Vladimir
