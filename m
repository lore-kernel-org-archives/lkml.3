Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab3DUIxG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 04:53:06 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:61402 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab3DUIxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 04:53:03 -0400
Date: Sun, 21 Apr 2013 10:52:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: George Dunlap <george.dunlap@eu.citrix.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>
Subject: Re: [PATCH v3] perf: Check all MSRs before passing hw check
Message-ID: <20130421085259.GA31470@gmail.com>
References: <1365000388-32448-1-git-send-email-george.dunlap@eu.citrix.com>
 <51717107.5070702@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51717107.5070702@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* George Dunlap <george.dunlap@eu.citrix.com> wrote:

> Any comments?  it's been 2 weeks now.

Looks good to me - Peter, any objections?

Thanks,

	Ingo
