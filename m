Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbaA0Qn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 11:43:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810AbaA0Qnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 11:43:55 -0500
Date: Mon, 27 Jan 2014 17:43:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Michael Matz <matz@suse.de>,
        Michal Hocko <mhocko@suse.cz>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] x86: Disable traditional FPU instructions too
In-Reply-To: <52E68C25.1070804@zytor.com>
Message-ID: <alpine.LNX.2.00.1401271742300.14101@pobox.suse.cz>
References: <20140127163758.GC6839@pd.tnic> <52E68C25.1070804@zytor.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jan 2014, H. Peter Anvin wrote:

> I don't think it'd hurt... although I think the above pretty much
> requires that the code contain actual floating-point types to ever be
> generated.  

Unfortunately using float-typed constants (such as 1EexpL) are enough for 
this to happen.

-- 
Jiri Kosina
SUSE Labs
