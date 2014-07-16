Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760558AbaGPIbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:31:31 -0400
Received: from mga14.intel.com ([192.55.52.115]:37062 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760537AbaGPIbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:31:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="362097982"
Message-ID: <1405499481.1906.3.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: init_volumes: Ignore volumes with no LEBs
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 16 Jul 2014 11:31:21 +0300
In-Reply-To: <1404828284-32643-1-git-send-email-richard@nod.at>
References: <1404828284-32643-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-08 at 16:04 +0200, Richard Weinberger wrote:
> UBI assumes that ubi_attach_info will only contain ubi_ainf_volume
> structures for volumes with at least one LEB.
> In scanning mode this is true because UBI can nicely create a ubi_ainf_volume
> on demand while creating the EBA table.

Applied to linux-ubifs.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

