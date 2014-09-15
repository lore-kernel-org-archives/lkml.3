Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbaIOVpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:45:23 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:37530 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719AbaIOVpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:45:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140915211541.GB5481@infradead.org>
References: <cover.1410810247.git.milosz@adfin.com>
	<b7faca081076f52327690ebb7fecd1f1bf05a07c.1410810247.git.milosz@adfin.com>
	<20140915211541.GB5481@infradead.org>
Date: Mon, 15 Sep 2014 17:45:18 -0400
Message-ID: <CANP1eJFkXuaN8YFFt+Dw9gZ0X4CP-3SOqEC_vgYd1U2V9QsLGA@mail.gmail.com>
Subject: Re: [PATCH 6/7] move flags enforcement to vfs_preadv/vfs_pwritev
From: Milosz Tanski <milosz@adfin.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will fix this for the next submission.

On Mon, Sep 15, 2014 at 5:15 PM, Christoph Hellwig <hch@infradead.org> wrote:
> This should simply be folded into patch 2.



-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
