Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab3DKUXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:23:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49670 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851Ab3DKUXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:23:35 -0400
Date: Thu, 11 Apr 2013 22:23:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86, FPU: Fix FPU initialization
Message-ID: <20130411202328.GA15955@pd.tnic>
References: <1365436666-9837-1-git-send-email-bp@alien8.de>
 <20130410110840.GA29752@gmail.com>
 <20130410122411.GE13394@pd.tnic>
 <20130410122527.GB8686@gmail.com>
 <20130410133251.GC6857@pd.tnic>
 <516586CF.90909@zytor.com>
 <20130410161122.GI6857@pd.tnic>
 <20130410212950.GA6899@pd.tnic>
 <20130411120952.GA18879@gmail.com>
 <51670E51.6020106@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51670E51.6020106@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 12:26:09PM -0700, H. Peter Anvin wrote:
> What host is this?

Judging by the DMI string in the oops:

> [   15.921486] Pid: 73, comm: hwclock Tainted: G        W    3.9.0-rc6+ #222032 System manufacturer System Product Name/A8N-E

it is an ASUS board with a K8 on it - probably Ingo's old K8 which
triggers all kinds of crap off an on.

8-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
