Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab3JXLxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 07:53:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39267 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab3JXLxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 07:53:09 -0400
Date: Thu, 24 Oct 2013 12:53:04 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Ramprasad Chinthekindi <Ramprasad.Chinthekindi@hgst.com>
Cc: Akhil Bhansali <Akhil.Bhansali@hgst.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Amit Phansalkar <Amit.Phansalkar@hgst.com>
Subject: Re: [PATCH] skd: Replaced custom debug PRINTKs with pr_debug
Message-ID: <20131024115304.GW14598@kernel.dk>
References: <24CA9A5C93173F48A9E3313B866A7C280F344E@MYMBX3.stec-inc.ad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24CA9A5C93173F48A9E3313B866A7C280F344E@MYMBX3.stec-inc.ad>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24 2013, Ramprasad Chinthekindi wrote:
> Hi Jens,
> 
> I'm resending the patch to replace custom debug macros with
> pr_debug(). Kindly please review and apply the patch.  Thanking you.

Thanks, that's a nice improvement. Applied.

-- 
Jens Axboe

