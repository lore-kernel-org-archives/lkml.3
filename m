Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaK0OyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:54:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:37594 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbaK0OyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:54:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,469,1413270000"; 
   d="scan'208";a="615044803"
Message-ID: <1417100049.5858.98.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/6] UBI: Fastmap: Care about the protection queue
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 27 Nov 2014 16:54:09 +0200
In-Reply-To: <1416835236-25185-2-git-send-email-richard@nod.at>
References: <1416835236-25185-1-git-send-email-richard@nod.at>
	 <1416835236-25185-2-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-24 at 14:20 +0100, Richard Weinberger wrote:
> Fastmap can miss a PEB if it is in the protection queue
> and not jet in the used tree.
> Treat every protected PEB as used.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Picked this one and pushed, thanks!

