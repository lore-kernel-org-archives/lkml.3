Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbaJaRCC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:02:02 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53548 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbaJaRCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:02:01 -0400
Date: Fri, 31 Oct 2014 17:01:56 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isofs: remove unused functions
Message-ID: <20141031170156.GK7996@ZenIV.linux.org.uk>
References: <1414757628-16326-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414757628-16326-1-git-send-email-sudipm.mukherjee@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 05:43:48PM +0530, Sudip Mukherjee wrote:
> commit "5b71ecfa78271d5c576f17156ed8a53981c1ecbb" removed the use
> two functions isofs_hash() and isofs_dentry_cmp() , but their
> definition was not removed.
> So, as these functions are not used anywhere so it is safe to
> remove them. It has been build tested after removing.

Umm...  Already in b0afd8e5db7b11aa9078e82e7f9abc30dc35a3c1 (and AFAICS
the incremental is the same as yours).
