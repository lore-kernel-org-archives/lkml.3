Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaDAL2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:28:31 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:62188 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbaDALSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:49 -0400
X-IronPort-AV: E=Sophos;i="4.97,771,1389744000"; 
   d="scan'208";a="115640178"
Message-ID: <1396351126.8667.109.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH net-next v2 1/2] xen-netback: Rename map ops
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <paul.durrant@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
Date: Tue, 1 Apr 2014 12:18:46 +0100
In-Reply-To: <1396278539-27639-1-git-send-email-zoltan.kiss@citrix.com>
References: <1396278539-27639-1-git-send-email-zoltan.kiss@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-31 at 16:08 +0100, Zoltan Kiss wrote:
> Rename identifiers to state explicitly that they refer to map ops.
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>

On the understanding that this is a pure rename:
Acked-by: Ian Campbell <ian.campbell@citrix.com>



