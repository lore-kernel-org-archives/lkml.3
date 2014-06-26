Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaFZGNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 02:13:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:45351 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbaFZGNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 02:13:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,548,1400050800"; 
   d="scan'208";a="561155468"
Message-ID: <1403763199.20275.39.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] sysctl: Add a feature to drop caches selectively
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Dave Chinner <david@fromorbit.com>
Cc: Thomas Knauth <thomas.knauth@gmx.de>, David Rientjes <rientjes@google.com>,
        Maksym Planeta <mcsim.planeta@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 26 Jun 2014 09:13:19 +0300
In-Reply-To: <20140626010606.GT4453@dastard>
References: <1403626213-7691-1-git-send-email-mcsim.planeta@gmail.com>
	 <alpine.DEB.2.02.1406241458140.29176@chino.kir.corp.google.com>
	 <1403677528.7903.103.camel@sauron.fi.intel.com>
	 <CABhLV03_PNFiwsvt+yitcsKxz5TeVECCFavdNkbgQ+XzQqASaw@mail.gmail.com>
	 <20140626010606.GT4453@dastard>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-26 at 11:06 +1000, Dave Chinner wrote:
> Your particular use case can be handled by directing your benchmark
> at a filesystem mount point and unmounting the filesystem in between 
> benchmark runs. There is no ned to adding kernel functionality for
> somethign that can be so easily acheived by other means, especially
> in benchmark environments where *everything* is tightly controlled.

If I was a benchmark writer, I would not be willing running it as root
to be able to mount/unmount, I would not be willing to require the
customer creating special dedicated partitions for the benchmark,
because this is too user-unfriendly. Or do I make incorrect assumptions?

Not that I need this syscall and trying to sell the idea to anyone, just
trying to understand the alternative you suggested.

-- 
Best Regards,
Artem Bityutskiy

