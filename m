Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaBTDu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 22:50:56 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:61716 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbaBTDuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 22:50:55 -0500
Date: Thu, 20 Feb 2014 11:50:26 +0800
From: Shaohua Li <shli@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [patch]blk-mq: remove obsolete comments
Message-ID: <20140220035026.GA21488@kernel.org>
References: <20140219122222.GB17818@kernel.org>
 <20140219172805.GA14338@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219172805.GA14338@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 09:28:05AM -0800, Christoph Hellwig wrote:
> On Wed, Feb 19, 2014 at 08:22:22PM +0800, Shaohua Li wrote:
> > 
> > We now have blk_mq_stop/start_queues API, delete the obsolete comments.
> 
> We do have the API, but the big question is if we want to require every
> driver to manually call it each time we get a busy return here.

block layer can't know if driver is ready to handle request, so I'm afraid
driver should manually call it.

Thanks,
Shaohua
