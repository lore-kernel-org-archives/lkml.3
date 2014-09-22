Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbaIVVUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:20:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59999 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbaIVVUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:20:14 -0400
Date: Mon, 22 Sep 2014 14:20:09 -0700
From: Darren Hart <dvhart@infradead.org>
To: Frans Klaver <fransklaver@gmail.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] eeepc-laptop: clean up control flow in *_rfkill_notifier
Message-ID: <20140922212008.GA49318@vmdeb7>
References: <1411251737-16072-1-git-send-email-fransklaver@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411251737-16072-1-git-send-email-fransklaver@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2014 at 12:22:17AM +0200, Frans Klaver wrote:
> Handle errors immediately in eeepc_register_rfkill_notifier and
> eeepc_unregister_rfkill_notifier. This clears up the control flow for the
> reader. It also removes unnecessary indentation.
> 
> Signed-off-by: Frans Klaver <fransklaver@gmail.com>

Queued, thanks Frans.

-- 
Darren Hart
Intel Open Source Technology Center
