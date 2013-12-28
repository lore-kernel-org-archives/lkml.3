Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab3L1NWx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 08:22:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755345Ab3L1NWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 08:22:52 -0500
Date: Sat, 28 Dec 2013 13:22:48 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk,
        agk@redhat.com, snitzer@redhat.com
Subject: Re: [dm-devel] [PATCG]DM: dm-compression: a compressed DM target
	for SSD
Message-ID: <20131228132248.GB16613@agk-dp.fab.redhat.com>
Mail-Followup-To: Shaohua Li <shli@kernel.org>,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk,
	agk@redhat.com, snitzer@redhat.com
References: <20131227062421.GA21053@kernel.org> <20131228125725.GA16613@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131228125725.GA16613@agk-dp.fab.redhat.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 28, 2013 at 12:57:25PM +0000, Alasdair G Kergon wrote:
> To use this compression target above dm-thin (likely to prefer larger
> block sizes), for example, could the block sizes be adapatable /
> configurable?

So a key feature of the underlying thin provisioning needs to be
efficient tracking of a small sector size (which doesn't suit the
existing dm-thin target).  This compression target could sometimes
benefit from a larger block size though, particularly where the 
data above has large blocks.

(Could we name this something like 'microcompression'?)
 
Alasdair

