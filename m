Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbaJUMVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:21:15 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:58275 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125AbaJUMVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:21:14 -0400
MIME-Version: 1.0
In-Reply-To: <20141021120653.GA9530@infradead.org>
References: <20141021120653.GA9530@infradead.org>
Date: Tue, 21 Oct 2014 08:21:13 -0400
Message-ID: <CAFtxgO5cPNTMqyY5Foqp_Y+pqCH=zTiatREn-4xRCTm8o5GLwA@mail.gmail.com>
Subject: Re: state of the osdblk driver?
From: Jeff Garzik <jgpobox@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Boaz Harrosh <ooo@electrozaur.com>, Jeff Garzik <jgarzik@pobox.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        osd-dev@open-osd.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop it, if there are no users.

It was simulating an OSD, but there did not seem to be much beyond
academic interest, and some interest in the use of aforementioned
block functions as a useful exercise in block driver writing.


On Tue, Oct 21, 2014 at 8:06 AM, Christoph Hellwig <hch@infradead.org> wrote:
> The osdblk driver hsa seen literally no change except for global
> API changes since it was merged, and I've never heard of a user.
>
> Is this something we want to keep around?  I just noticed it because
> it's the only non-SCSI user of some of the old block layer tagging
> functions.
