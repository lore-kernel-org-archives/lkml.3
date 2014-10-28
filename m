Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286AbaJ1E4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 00:56:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36679 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbaJ1E4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 00:56:35 -0400
Date: Mon, 27 Oct 2014 21:56:31 -0700
From: Darren Hart <dvhart@infradead.org>
To: Frans Klaver <fransklaver@gmail.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] eeepc-laptop: flatten control flow
Message-ID: <20141028045631.GD60814@vmdeb7>
References: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
 <1414005163-3461-2-git-send-email-fransklaver@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414005163-3461-2-git-send-email-fransklaver@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 09:12:36PM +0200, Frans Klaver wrote:
> In eeepc_rfkill_hotplug there's an if statement with a big tail that
> ends right before the out_unlock label. We might as well invert the
> condition and jump to out_unlock in that case, pretty much like the rest
> of the code does. This removes an indentation level for a large chunk of
> code and also stops suggesting there might be an else clause.
> 
> Signed-off-by: Frans Klaver <fransklaver@gmail.com>

Queued for 3.19, thanks Frans.

-- 
Darren Hart
Intel Open Source Technology Center
