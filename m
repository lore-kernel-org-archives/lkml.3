Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751112AbaBEItS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 03:49:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbaBEItQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 03:49:16 -0500
Date: Wed, 5 Feb 2014 09:50:48 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 1/3] ath10k: Get rid of superfluous call to
 pci_disable_msi()
Message-ID: <20140205085047.GA27820@dhcp-26-207.brq.redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com>
 <ad5cc6d6bdf4c8f5ce4681ec27674d07fbda089e.1389904167.git.agordeev@redhat.com>
 <20140130134819.GA31909@dhcp-26-207.brq.redhat.com>
 <87y51qohjn.fsf@kamboji.qca.qualcomm.com>
 <20140204190935.GA1430@dhcp-26-207.brq.redhat.com>
 <8761oum0l3.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761oum0l3.fsf@kamboji.qca.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 10:21:28AM +0200, Kalle Valo wrote:
> Is it ok for me to take these patches to my ath.git tree or would you
> prefer to route them some other way?

Yeah, Bjorn has indicated he would pull it to his tree.
I get it you are fine with 2/3 and 3/3?

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
