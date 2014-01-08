Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbaAHMpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 07:45:05 -0500
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:52000 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738AbaAHMpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 07:45:02 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,7311"; a="57508440"
X-IronPort-AV: E=McAfee;i="5400,1158,7311"; a="661987870"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Alexander Gordeev <agordeev@redhat.com>
CC: <linux-pci@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 6/7] ath10k: Use new interfaces for MSI enablement
References: <cover.1389103215.git.agordeev@redhat.com>
	<dc640013c28e6e24b4f7293a8adbd2b60a8f48c4.1389103215.git.agordeev@redhat.com>
	<87txdehog9.fsf@kamboji.qca.qualcomm.com>
	<20140108090449.GC20157@dhcp-26-207.brq.redhat.com>
Date: Wed, 8 Jan 2014 14:44:55 +0200
In-Reply-To: <20140108090449.GC20157@dhcp-26-207.brq.redhat.com> (Alexander
	Gordeev's message of "Wed, 8 Jan 2014 10:04:50 +0100")
Message-ID: <87ob3mfxrs.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Gordeev <agordeev@redhat.com> writes:

> On Wed, Jan 08, 2014 at 10:23:18AM +0200, Kalle Valo wrote:
>
>> Do you want me to take this patch to my ath.git tree or how were you
>> planning to handle it?
>
> I see no option other than pushing it thru pci.git tree at this stage.

Thanks, I'll then just drop it from my queue.

-- 
Kalle Valo
