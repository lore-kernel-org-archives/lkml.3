Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919Ab3CYVNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 17:13:18 -0400
Received: from mail.windriver.com ([147.11.1.11]:54697 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758551Ab3CYVNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 17:13:17 -0400
Message-ID: <5150BD98.2030606@windriver.com>
Date: Mon, 25 Mar 2013 16:11:52 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        <kgdb-bugreport@lists.sourceforge.net>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 01/15] KDB: fix the interrupt of the KDB btc command
References: <20130325185007.321022858@gulag1.americas.sgi.com> <20130325185007.496292277@gulag1.americas.sgi.com>
In-Reply-To: <20130325185007.496292277@gulag1.americas.sgi.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 01:50 PM, Mike Travis wrote:
> The KDB 'btc' (backtrace cpus) command ignores the 'quit' reply
> to the 'more>' prompt.  This is quite annoying when you have a
> large number of processors and thousands of lines are being
> printed.  This fixes that problem.
> 

Merged to kgdb-next and added as a cc to -stable.

I'll be working my way through the rest of the patches in the series you sent and I'll merge anything that is going to -stable in the 3.9 series toward the end of the week assuming everything passes regression testing, and the rest will go into the 3.10 merge window.

Cheers,
Jason.
