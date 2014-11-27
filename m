Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151AbaK0P1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:27:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:19924 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbaK0P1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:27:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,470,1413270000"; 
   d="scan'208";a="629250403"
Message-ID: <1417102042.5858.102.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 2/6] UBI: Fastmap: Ensure that only one fastmap work is
 scheduled
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 27 Nov 2014 17:27:22 +0200
In-Reply-To: <1416835236-25185-3-git-send-email-richard@nod.at>
References: <1416835236-25185-1-git-send-email-richard@nod.at>
	 <1416835236-25185-3-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-24 at 14:20 +0100, Richard Weinberger wrote:
> If the WL pool runs out of PEBs we schedule a fastmap write
> to refill it as soon as possible.
> Ensure that only one at a time is scheduled otherwise we might end in
> a fastmap write storm because writing the fastmap can schedule another
> write if bitflips are detected.

Could you please provide some more details about the "write storm". Does
it happen when there are 2 fastmap works in the queue? Or if they run
simultaneously? Why the storm happens and white kind of "writes" it
consists of?

Thanks!

