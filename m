Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbaBEIyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 03:54:45 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22808 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaBEIyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 03:54:43 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,7339"; a="103121542"
X-IronPort-AV: E=McAfee;i="5400,1158,7339"; a="588876756"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Alexander Gordeev <agordeev@redhat.com>
CC: <linux-pci@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/3] ath10k: Get rid of superfluous call to pci_disable_msi()
References: <cover.1389904166.git.agordeev@redhat.com>
	<ad5cc6d6bdf4c8f5ce4681ec27674d07fbda089e.1389904167.git.agordeev@redhat.com>
	<20140130134819.GA31909@dhcp-26-207.brq.redhat.com>
	<87y51qohjn.fsf@kamboji.qca.qualcomm.com>
	<20140204190935.GA1430@dhcp-26-207.brq.redhat.com>
	<8761oum0l3.fsf@kamboji.qca.qualcomm.com>
	<20140205085047.GA27820@dhcp-26-207.brq.redhat.com>
Date: Wed, 5 Feb 2014 10:54:37 +0200
In-Reply-To: <20140205085047.GA27820@dhcp-26-207.brq.redhat.com> (Alexander
	Gordeev's message of "Wed, 5 Feb 2014 09:50:48 +0100")
Message-ID: <871tzilz1u.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Gordeev <agordeev@redhat.com> writes:

> On Wed, Feb 05, 2014 at 10:21:28AM +0200, Kalle Valo wrote:
>> Is it ok for me to take these patches to my ath.git tree or would you
>> prefer to route them some other way?
>
> Yeah, Bjorn has indicated he would pull it to his tree.

Ok, I'll drop these from my pending branch then. I just think it would
have been easier if I would take these, smaller chance of conflicts that
way.

> I get it you are fine with 2/3 and 3/3?

Yes, with the addition of the commit log to 1/3 I'll give:

Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>

-- 
Kalle Valo
