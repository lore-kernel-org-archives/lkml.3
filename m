Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab3KMDIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 22:08:30 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:65183 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061Ab3KMDIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 22:08:22 -0500
Date: Wed, 13 Nov 2013 04:08:18 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@suse.de>, linux-kernel@vger.kernel.org,
        stable@kernel.org, tglx@linutronix.de, trenn@suse.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/microcode/amd: Tone down printk(), don' t
 treat a missing firmware file as an error
Message-ID: <20131113030818.GA3823@gmail.com>
References: <1384274383-43510-1-git-send-email-trenn@suse.de>
 <tip-11f918d3e2d3861b6931e97b3aa778e4984935aa@git.kernel.org>
 <20131112224511.GJ12854@pd.tnic>
 <20131112230016.GA30674@gmail.com>
 <5282DFF0.5050108@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5282DFF0.5050108@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 11/12/2013 03:00 PM, Ingo Molnar wrote:
> > 
> > Indeed that is the documented alias, although stable@kernel.org works 
> > as well and is used frequently:
> > 
> 
> No, it doesn't; it has bounced for the past two years.

'works' as in the patches get picked up into -stable by Greg. :-)

Thanks,

	Ingo
