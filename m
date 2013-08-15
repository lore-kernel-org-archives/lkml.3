Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab3HONXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 09:23:47 -0400
Received: from smtp.citrix.com ([66.165.176.89]:55862 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755067Ab3HONXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 09:23:46 -0400
X-IronPort-AV: E=Sophos;i="4.89,885,1367971200"; 
   d="scan'208";a="44544422"
Message-ID: <520CD660.7060504@citrix.com>
Date: Thu, 15 Aug 2013 14:23:44 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        Chuck Anderson <chuck.anderson@oracle.com>
Subject: Re: [Xen-devel] [PATCH] xen/smp: initialize IPI vectors before marking
 CPU online
References: <1376512905-8101-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1376512905-8101-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/08/13 21:41, Konrad Rzeszutek Wilk wrote:
> From: Chuck Anderson <chuck.anderson@oracle.com>
> 
> An older PVHVM guest (v3.0 based) crashed during vCPU hot-plug with:
> 
> 	kernel BUG at drivers/xen/events.c:1328!

The commit message is perhaps a little wordy but this is better than
being too short so.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
