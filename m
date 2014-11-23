Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaKWTA3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 14:00:29 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55716 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419AbaKWTA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 14:00:28 -0500
X-Sasl-enc: XwCZ30Md96CblXd1Zjy01MPpvQDf7AzqoTejgl3+Q/7/ 1416769226
Date: Sun, 23 Nov 2014 11:00:25 -0800
From: Greg KH <greg@kroah.com>
To: Balavasu kuppusammyprathaban <kp.balavasu@gmail.com>
Cc: linux-kernel@vger.kernel.org, andreas.dilger@intel.com,
        oleg.drokin@intel.com
Subject: Re: [PATCH 1/2] staging: lustre: lnet: lnet: do not initialise
 statics to 0 or NULL
Message-ID: <20141123190025.GA9346@kroah.com>
References: <20141123184521.GA6581@vasu-Inspiron-3542>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141123184521.GA6581@vasu-Inspiron-3542>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 12:15:21AM +0530, Balavasu kuppusammyprathaban wrote:
> This patch fixes the checkpatch.pl issue
> Error: do not initialise statics to 0 or NULL 
> 
> Signed-off-by: Balavasu <kp.balavasu@gmail.com>

You seem to have ignored everything I said in my last response to your
previous submission, which is a bit rude, don't you think?

