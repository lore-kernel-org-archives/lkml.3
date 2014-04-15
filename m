Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750911AbaDOIQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:16:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51286 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaDOIQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:16:14 -0400
Date: Tue, 15 Apr 2014 09:16:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org, geert@linux-m68k.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cif: fix dead code
Message-ID: <20140415081612.GV18016@ZenIV.linux.org.uk>
References: <1397549210-29445-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397549210-29445-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 10:06:50AM +0200, Michael Opdenacker wrote:
> This issue was found by Coverity (CID 1202536)
> 
> This proposes a fix for a statement that creates dead code.
> The "rc < 0" statement is within code that is run
> with "rc > 0".
> 
> It seems like "err < 0" was meant to be used here.
> This way, the error code is returned by the function.

Acked-by: Al Viro <viro@zeniv.linux.org.uk>
