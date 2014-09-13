Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbaIMT4G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 15:56:06 -0400
Received: from verein.lst.de ([213.95.11.211]:58269 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbaIMT4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 15:56:03 -0400
Date: Sat, 13 Sep 2014 21:55:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andy Grover <agrover@redhat.com>, nab@linux-iscsi.org
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCHv3 0/8] target: Save memory on unused se_dev_entrys and
	se_luns
Message-ID: <20140913195557.GA32118@lst.de>
References: <1404171587-28845-1-git-send-email-agrover@redhat.com> <20140729131511.GA30232@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140729131511.GA30232@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 03:15:11PM +0200, Christoph Hellwig wrote:
> Nic,
> 
> any progress on looking over these?  Seems like there's actually
> nothing at all queued up for 3.17 in the target tree, or am І missing
> something?

ping again.  We're getting closer to the end of the 3.18 merge window
and there still hasn't been a response.  Should Andy just send the patches
directly to Linus once 3.18 opens given that they have been out on the list
since Jun 23? (with a positive review from me and no negative one)

