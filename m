Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbaAHJDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 04:03:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049AbaAHJDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 04:03:10 -0500
Date: Wed, 8 Jan 2014 10:04:50 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 6/7] ath10k: Use new interfaces for MSI enablement
Message-ID: <20140108090449.GC20157@dhcp-26-207.brq.redhat.com>
References: <cover.1389103215.git.agordeev@redhat.com>
 <dc640013c28e6e24b4f7293a8adbd2b60a8f48c4.1389103215.git.agordeev@redhat.com>
 <87txdehog9.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txdehog9.fsf@kamboji.qca.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 10:23:18AM +0200, Kalle Valo wrote:
> Looks good to me.
> 
> Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>

Thanks, Kalle.

> Do you want me to take this patch to my ath.git tree or how were you
> planning to handle it?

I see no option other than pushing it thru pci.git tree at this stage.

> -- 
> Kalle Valo

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
