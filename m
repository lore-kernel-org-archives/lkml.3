Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933933AbaKMTRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:17:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933528AbaKMTRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:17:06 -0500
Date: Thu, 13 Nov 2014 11:17:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pratik Patel <pratikp@codeaurora.org>
Subject: Re: [PATCH 0/3] miscellaneous fixes in coresight
Message-ID: <20141113191704.GA28033@kroah.com>
References: <1415868169-13325-1-git-send-email-pankaj.dubey@samsung.com>
 <CANLsYkyPnVJ75-TYYionMtd2KJzs29UK9LD3Fj4vk=Apvfh0Gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANLsYkyPnVJ75-TYYionMtd2KJzs29UK9LD3Fj4vk=Apvfh0Gw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 11:12:40AM -0700, Mathieu Poirier wrote:
> On 13 November 2014 01:42, Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
> > This patch series fixes some typo and minor issues in coresight which
> > I observed while going through this driver.
> >
> > Pankaj Dubey (3):
> >   coresight: fix typo in comment in coresight-priv.h
> >   coresight: fixed comments in coresight.h
> >   coresight-replicator: remove .owner field for driver
> >
> >  drivers/coresight/coresight-priv.h       |    2 +-
> >  drivers/coresight/coresight-replicator.c |    1 -
> >  include/linux/coresight.h                |    6 +++---
> >  3 files changed, 4 insertions(+), 5 deletions(-)
> >
> > --
> > 1.7.9.5
> >
> 
> Applied all 3 patches - thanks

Applied to what?  Shouldn't I be taking these?

confused,

greg k-h
