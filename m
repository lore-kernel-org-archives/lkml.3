Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaKDGBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 01:01:49 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:47637 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbaKDGBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 01:01:44 -0500
Date: Mon, 3 Nov 2014 22:01:35 -0800
From: Darren Hart <dvhart@infradead.org>
To: Frans Klaver <fransklaver@gmail.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] eeepc-laptop: clean up control flow in
 eeepc_acpi_notify
Message-ID: <20141104060135.GB56751@vmdeb7>
References: <20141028052517.GG60814@vmdeb7>
 <1414962898-13917-1-git-send-email-fransklaver@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414962898-13917-1-git-send-email-fransklaver@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2014 at 10:14:58PM +0100, Frans Klaver wrote:
> eeepc_acpi_notify increases the indentation level to a whopping four. If
> we revise the conditions a bit, we can reduce that to a more soothing
> two and satisfy the indentation guidelines in Documentation/CodingStyle.
> 
> Remove an unwanted space while we're in the neighbourhood.
> 
> Signed-off-by: Frans Klaver <fransklaver@gmail.com>

Applied, thanks. Look for this in my 3.19 pull requests along with the other
cleanups.

-- 
Darren Hart
Intel Open Source Technology Center
