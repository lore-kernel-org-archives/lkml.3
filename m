Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaBRRYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:24:51 -0500
Received: from smtp.citrix.com ([66.165.176.89]:56561 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbaBRRYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:24:49 -0500
X-IronPort-AV: E=Sophos;i="4.97,502,1389744000"; 
   d="scan'208";a="103587428"
Message-ID: <1392744286.23084.52.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH net-next v5 1/9] xen-netback: Introduce TX grant map
 definitions
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>
Date: Tue, 18 Feb 2014 17:24:46 +0000
In-Reply-To: <1390253069-25507-2-git-send-email-zoltan.kiss@citrix.com>
References: <1390253069-25507-1-git-send-email-zoltan.kiss@citrix.com>
	 <1390253069-25507-2-git-send-email-zoltan.kiss@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-20 at 21:24 +0000, Zoltan Kiss wrote:
> 
> +       spinlock_t dealloc_lock;
> +       spinlock_t response_lock; 

Please add comments to both of these describing what bits of the
datastructure they are locking.

You might find it is clearer to group the locks and the things they
protect together rather than grouping the locks together.

Ian.

