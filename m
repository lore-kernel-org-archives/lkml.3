Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143AbaEMKsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:48:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:36961 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932769AbaEMKsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:48:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1043,1389772800"; 
   d="scan'208";a="531042955"
Message-ID: <1399978082.1797.30.camel@sauron.fi.intel.com>
Subject: Re: [RFC PATCH] UBI: fix rb_tree node comparison in add_map
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
Date: Tue, 13 May 2014 13:48:02 +0300
In-Reply-To: <20140321195403.GA32529@redhat.com>
References: <20140321195403.GA32529@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-21 at 15:54 -0400, Mike Snitzer wrote:
> The comparisons used in add_vol() shouldn't be identical.  Pretty sure
> the following is correct but it is completely untested.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>

Pushed to linux-ubifs.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

