Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbaHOTW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:22:59 -0400
Received: from verein.lst.de ([213.95.11.211]:50947 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbaHOTW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:22:57 -0400
Date: Fri, 15 Aug 2014 21:22:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Guenter Roeck <linux@roeck-us.net>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Webb Scales <webbnh@hp.com>
Subject: Re: [PATCH] scsi: Fix qemu boot hang problem
Message-ID: <20140815192253.GA22752@lst.de>
References: <1407675265-29192-1-git-send-email-linux@roeck-us.net> <53EE4FDE.2070904@roeck-us.net> <53EE52AE.4050006@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EE52AE.4050006@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 12:34:22PM -0600, Jens Axboe wrote:
> On 2014-08-15 12:22, Guenter Roeck wrote:
>> ping ... the problem fixed by this patch still affects the upstream kernel
>> (v3.16-11383-gc9d2642) as well as -next (20140815).
>
> James, could you upstream this one in time for -rc1?

It's in the core-for-3.17 updates I sent to James yesterday, just needs to
be forwarded..

