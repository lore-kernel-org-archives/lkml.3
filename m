Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab3BENSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 08:18:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47013 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab3BENST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 08:18:19 -0500
Date: Tue, 5 Feb 2013 14:17:17 +0100
From: Jens Axboe <axboe@kernel.dk>
To: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        brking@linux.vnet.ibm.com, josh.h.morris@us.ibm.com
Subject: Re: [PATCHv2 1/1] block: IBM RamSan 70/80 device driver.
Message-ID: <20130205131717.GS15092@kernel.dk>
References: <20130201214139.GB6971@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130201214139.GB6971@oc6784271780.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01 2013, Philip J. Kelleher wrote:
> From: Joshua H Morris <josh.h.morris@us.ibm.com>
> 	Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
> 
> This patch includes the device driver for the IBM RamSan family
> of PCI SSD flash storage cards. This driver will inlcude support for the
> RamSan 70 and 80. The driver presents a block device for device I/O.
> 
> Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
> -------------------------------------------------------------------------------
> This update addresses all issues raised thus far. Changes include:
> o Moved blk_queue_max_discard_sectors into the 'discard supported' if
>   statement.
> o Changed email address to linux.vnet.ibm.com

Tentatively applied for 3.9.

-- 
Jens Axboe

