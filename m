Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbaESITR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:19:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37114 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbaESITP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:19:15 -0400
Date: Mon, 19 May 2014 10:18:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chen Yucong <slaoub@gmail.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org
Subject: Re: [PATCH] x86/mce: Distirbute the clear operation of mces_seen to
 Per-CPU rather than only monarch CPU
Message-ID: <20140519081856.GB6311@pd.tnic>
References: <1400425504-8821-1-git-send-email-slaoub@gmail.com>
 <20140518163508.GA8003@pd.tnic>
 <1400464540.9630.31.camel@debian>
 <20140519072619.GA6311@pd.tnic>
 <1400486094.10554.3.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1400486094.10554.3.camel@debian>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 03:54:54PM +0800, Chen Yucong wrote:
> If a timeout occurs in monarch CPU, what will happen for the above
> code segment?

I think I answered that question already, didn't I?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
