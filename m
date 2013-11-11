Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab3KKTkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:40:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43163 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab3KKTjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:39:51 -0500
Date: Mon, 11 Nov 2013 12:39:47 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Kent Overstreet <kmo@daterainc.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] percpu_ida: Various tweaks
Message-ID: <20131111193947.GD25231@kernel.dk>
References: <20131028100440.GA5744@dhcp-26-207.brq.redhat.com>
 <1382995746.19256.756.camel@haakon3.risingtidesystems.com>
 <20131111193433.GA9679@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111193433.GA9679@dhcp-26-207.brq.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11 2013, Alexander Gordeev wrote:
> On Mon, Oct 28, 2013 at 02:29:06PM -0700, Nicholas A. Bellinger wrote:
> > I'll wait for Kent's feedback on these, and end-up dropping the
> > blk-mq-tag part from Patch #5 for the moment..
> 
> Hi Nicholas,
> 
> I am bit uncertain regarding the process concerning your and Jens trees.
> Are you planning to pull Shaohua's percpu_ida conversion?

The submitted blk-mq bits have the conversion, the old tagging is no
longer active/maintained. So any work on this going forward will have to
be based on the percpu ida conversion.

-- 
Jens Axboe

