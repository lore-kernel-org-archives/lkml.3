Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762109AbaGRPZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:25:12 -0400
Received: from smtp.citrix.com ([66.165.176.89]:53708 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761928AbaGRPZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:25:09 -0400
X-IronPort-AV: E=Sophos;i="5.01,685,1400025600"; 
   d="scan'208";a="153716013"
Date: Fri, 18 Jul 2014 16:25:08 +0100
From: Wei Liu <wei.liu2@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: Wei Liu <wei.liu2@citrix.com>, Ian Campbell <Ian.Campbell@citrix.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH net 4/4] xen-netback: Fix pointer incrementation to avoid
 incorrect logging
Message-ID: <20140718152508.GQ7142@zion.uk.xensource.com>
References: <1405624192-21722-1-git-send-email-zoltan.kiss@citrix.com>
 <1405624192-21722-5-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1405624192-21722-5-git-send-email-zoltan.kiss@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 08:09:52PM +0100, Zoltan Kiss wrote:
> Due to this pointer is increased prematurely, the error log contains rubbish.
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> Reported-by: Armin Zentai <armin.zentai@ezit.hu>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: xen-devel@lists.xenproject.org

Acked-by: Wei Liu <wei.liu2@citrix.com>
