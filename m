Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaG2WnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 18:43:00 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:36954 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaG2Wm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 18:42:58 -0400
Date: Tue, 29 Jul 2014 15:42:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Borislav Petkov <bp@alien8.de>
cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
        lszubowi@redhat.com, Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
In-Reply-To: <20140729223603.GC17241@pd.tnic>
Message-ID: <alpine.DEB.2.02.1407291541480.20991@chino.kir.corp.google.com>
References: <1406653761-3884-1-git-send-email-prarit@redhat.com> <20140729222932.GA17481@pd.tnic> <53D82118.6090202@redhat.com> <20140729223603.GC17241@pd.tnic>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2014, Borislav Petkov wrote:

> On Tue, Jul 29, 2014 at 06:32:56PM -0400, Prarit Bhargava wrote:
> > and it was best to keep the code simple with a KiB.
> 
> You're missing the point - the output doesn't get simple with KiB. Read
> the example I just gave you!
> 
> (13893632kiB) is actively *not* helping when one looks at it!
> 

/proc/meminfo must be frustrating then, too.

If Prarit is going to implement this suggested reverse memparse() then it 
would be nice to also have it as a generic function that others can use.
