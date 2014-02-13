Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaBMQFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 11:05:06 -0500
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:64298 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaBMQFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 11:05:03 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,7347"; a="59413535"
X-IronPort-AV: E=Sophos;i="4.95,839,1384329600"; 
   d="scan'208";a="27145215"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Alexander Gordeev <agordeev@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/3] ath10k: Get rid of superfluous call to pci_disable_msi()
References: <cover.1389904166.git.agordeev@redhat.com>
	<ad5cc6d6bdf4c8f5ce4681ec27674d07fbda089e.1389904167.git.agordeev@redhat.com>
	<20140130134819.GA31909@dhcp-26-207.brq.redhat.com>
Date: Thu, 13 Feb 2014 18:04:57 +0200
In-Reply-To: <20140130134819.GA31909@dhcp-26-207.brq.redhat.com> (Alexander
	Gordeev's message of "Thu, 30 Jan 2014 14:48:20 +0100")
Message-ID: <87vbwj6lsm.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Gordeev <agordeev@redhat.com> writes:

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

Thanks, all three patches applied to my ath.git tree.

-- 
Kalle Valo
