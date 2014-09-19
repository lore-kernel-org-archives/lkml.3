Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbaISPPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:15:40 -0400
Received: from mga14.intel.com ([192.55.52.115]:56156 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757150AbaISPPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:15:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,555,1406617200"; 
   d="scan'208";a="593875948"
Message-ID: <1411139731.28850.145.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/2] UBIFS: Remove bogus assert
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 19 Sep 2014 18:15:31 +0300
In-Reply-To: <1411120127-18787-1-git-send-email-richard@nod.at>
References: <1411120127-18787-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-19 at 11:48 +0200, Richard Weinberger wrote:
> This assertion was only correct before UBIFS had xattr support.
> Now with xattr support also a directory node can carry data
> and can act as host node.
> 
> Suggested-by: Artem Bityutskiy <dedekind1@gmail.com>
> Signed-off-by: Richard Weinberger <richard@nod.at>

Pushed both, thank you!

-- 
Best Regards,
Artem Bityutskiy

