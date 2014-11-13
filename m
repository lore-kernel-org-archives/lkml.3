Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896AbaKMMaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 07:30:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34116 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932416AbaKMMay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 07:30:54 -0500
Date: Thu, 13 Nov 2014 13:30:45 +0100
From: Borislav Petkov <bp@suse.de>
To: B_B_Singh@DELL.com
Cc: stuart.w.hayes@gmail.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        matt.fleming@intel.com, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] x86: Configure NX support earlier in setup_arch
Message-ID: <20141113123045.GA14421@pd.tnic>
References: <53B4B627.8060903@gmail.com>
 <53BC7210.1000305@gmail.com>
 <53BC72D8.4090705@zytor.com>
 <53BDE4BD.50605@gmail.com>
 <20140714172225.GE25120@pd.tnic>
 <8B2F6FFD0BD1E448853114367400A3730702007068@BLRX7MCDC203.AMER.DELL.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8B2F6FFD0BD1E448853114367400A3730702007068@BLRX7MCDC203.AMER.DELL.COM>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 12:09:02PM +0530, B_B_Singh@DELL.com wrote:
> I feel this can be a valid scenario where user wants to disable the
> memory protection (NX flag disable) for his requirement, in that case he
> will hit this issue. So request you to please revisit this patch.

First of all, please do not top-post. Here's why:

A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

Revisit this patch how? I'm not sure I understand...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
