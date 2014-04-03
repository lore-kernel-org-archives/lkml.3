Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730AbaDCJHC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 05:07:02 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:26689 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106AbaDCJG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 05:06:57 -0400
X-IronPort-AV: E=Sophos;i="4.97,785,1389744000"; 
   d="scan'208";a="116374005"
Message-ID: <1396516014.4211.38.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH net-next v3 1/2] xen-netback: Rename map ops
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <paul.durrant@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
Date: Thu, 3 Apr 2014 10:06:54 +0100
In-Reply-To: <1396458298-30041-1-git-send-email-zoltan.kiss@citrix.com>
References: <1396458298-30041-1-git-send-email-zoltan.kiss@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-02 at 18:04 +0100, Zoltan Kiss wrote:
> Rename identifiers to state explicitly that they refer to map ops.
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> ---
> v3:
> - rename xenvif_tx_create_gop to xenvif_tx_create_map_op

You can retain my ack from v2.


