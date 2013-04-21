Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab3DURuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 13:50:11 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34018
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753512Ab3DURuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 13:50:09 -0400
Message-ID: <1366566593.32560.1.camel@laptop>
Subject: Re: [PATCH v3] perf: Check all MSRs before passing hw check
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@kernel.org>
Cc: George Dunlap <george.dunlap@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>
Date: Sun, 21 Apr 2013 19:49:53 +0200
In-Reply-To: <20130421085259.GA31470@gmail.com>
References: <1365000388-32448-1-git-send-email-george.dunlap@eu.citrix.com>
	 <51717107.5070702@eu.citrix.com> <20130421085259.GA31470@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-04-21 at 10:52 +0200, Ingo Molnar wrote:
> * George Dunlap <george.dunlap@eu.citrix.com> wrote:
> 
> > Any comments?  it's been 2 weeks now.
> 
> Looks good to me - Peter, any objections?

Nope, looks good.


