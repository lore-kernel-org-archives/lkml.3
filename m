Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab3J2Hy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 03:54:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab3J2HyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 03:54:25 -0400
Date: Tue, 29 Oct 2013 08:56:31 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Kent Overstreet <kmo@daterainc.com>, Oleg Nesterov <oleg@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] percpu_ida: Various tweaks
Message-ID: <20131029075630.GA23958@dhcp-26-207.brq.redhat.com>
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

Hi Nicholas,

> So this series is atop Shaohua's conversion blk-mq patch to use
> percpu_ida, right..?

Yep.

> I'll wait for Kent's feedback on these, and end-up dropping the
> blk-mq-tag part from Patch #5 for the moment..

Yeah, looking forward to try AHCI with percpu_ida.

> --nab

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
