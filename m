Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab3KKTcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:32:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119Ab3KKTcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:32:33 -0500
Date: Mon, 11 Nov 2013 20:34:34 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Kent Overstreet <kmo@daterainc.com>, Oleg Nesterov <oleg@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] percpu_ida: Various tweaks
Message-ID: <20131111193433.GA9679@dhcp-26-207.brq.redhat.com>
References: <20131028100440.GA5744@dhcp-26-207.brq.redhat.com>
 <1382995746.19256.756.camel@haakon3.risingtidesystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382995746.19256.756.camel@haakon3.risingtidesystems.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 02:29:06PM -0700, Nicholas A. Bellinger wrote:
> I'll wait for Kent's feedback on these, and end-up dropping the
> blk-mq-tag part from Patch #5 for the moment..

Hi Nicholas,

I am bit uncertain regarding the process concerning your and Jens trees.
Are you planning to pull Shaohua's percpu_ida conversion?

Thanks!

> --nab

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
