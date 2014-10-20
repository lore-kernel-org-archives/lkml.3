Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaJTNxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 09:53:22 -0400
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbaJTNxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 09:53:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,756,1406617200"; 
   d="scan'208";a="592391296"
Message-ID: <1413813193.7906.295.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v4] mtd: ubi: Extend UBI layer debug/messaging
 capabilities
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joe Perches <joe@perches.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Tanya Brokhman <tlinder@codeaurora.org>, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        open list <linux-kernel@vger.kernel.org>
Date: Mon, 20 Oct 2014 16:53:13 +0300
In-Reply-To: <1413315062.10221.1.camel@joe-AO725>
References: <1413296037-22346-1-git-send-email-tlinder@codeaurora.org>
	 <20141014143902.GA9768@arch.hh.imgtec.org>
	 <1413299343.7906.103.camel@sauron.fi.intel.com>
	 <20141014184702.GA12662@arch.hh.imgtec.org>
	 <1413314020.26864.7.camel@joe-AO725>
	 <20141014191815.GB12662@arch.hh.imgtec.org>
	 <1413315062.10221.1.camel@joe-AO725>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-14 at 12:31 -0700, Joe Perches wrote:
> On Tue, 2014-10-14 at 16:18 -0300, Ezequiel Garcia wrote:
> > On 14 Oct 12:13 PM, Joe Perches wrote:
> > > On Tue, 2014-10-14 at 15:47 -0300, Ezequiel Garcia wrote:
> []
> > > > When the gendisk is not available, a simple pr_{} would work.
> > > 
> > > Or maybe combine these in the ubi_<level> calls passing
> > > NULL when there is no struct ubi_device *
> []
> > Isn't this excessive obfuscation? What's the benefit of it?
> 
> Single error message type.

Well, these are 2 separate drivers just living in the same folder, so
they do not have to have to share message functions.

Artem.


