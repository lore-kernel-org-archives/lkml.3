Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab3EMH4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 03:56:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:18353 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab3EMH4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 03:56:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,660,1363158000"; 
   d="scan'208";a="240652138"
Message-ID: <1368431932.5360.25.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: Convert logging messages
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Joe Perches <joe@perches.com>, Joern Engel <joern@lazybastard.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 13 May 2013 10:58:52 +0300
In-Reply-To: <20130423165132.GA21580@logfs.org>
References: <1366394375.3901.36.camel@joe-AO722>
	 <20130419165516.GA19480@logfs.org> <1366396053.3901.40.camel@joe-AO722>
	 <20130422143118.GA12908@logfs.org> <1366739994.2036.1.camel@joe-AO722>
	 <20130423165132.GA21580@logfs.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-23 at 12:51 -0400, Jörn Engel wrote:
> In that case: NAK.
> 
> Because you personally dislike something isn't
> enough of a reason for me to take your patch nor
> enough of a reason for me to add a special
> exception to my standards for your preferences.
> 
> Cuts both way, it seems.

Hi Jörn,

I think the patch is useful so I am taking it to my l2 tree. I do not
want to annoy you at all, I just think that it is not fair to drop a
tiny, but still useful cleanup just because of a bitten to death
indentation question.

David may judge himself if he wants the patch or not, but I personally
think the patch is all-right.

-- 
Best Regards,
Artem Bityutskiy

