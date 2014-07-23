Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479AbaGWVKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 17:10:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51260 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933225AbaGWVKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:10:22 -0400
Message-ID: <1406149813.3612.42.camel@fourier>
Subject: Re: [PATCH 3.8 106/116] x86_32, entry: Do syscall exit work on
 badsys (CVE-2014-4508)
From: Kamal Mostafa <kamal@canonical.com>
To: Andy Lutomirski <luto@amacapital.net>, Greg KH <greg@kroah.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, kernel-team@lists.ubuntu.com,
        Roland McGrath <roland@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Wed, 23 Jul 2014 14:10:13 -0700
In-Reply-To: <CALCETrWTS=z7ZD78JppwbXJKo7HA3xTJYQS=DXLbw5bNyUA_3g@mail.gmail.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
	 <1406067727-19683-107-git-send-email-kamal@canonical.com>
	 <CALCETrWTS=z7ZD78JppwbXJKo7HA3xTJYQS=DXLbw5bNyUA_3g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-22 at 15:27 -0700, Andy Lutomirski wrote:
> On Tue, Jul 22, 2014 at 3:21 PM, Kamal Mostafa <kamal@canonical.com> wrote:
> > 3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Andy Lutomirski <luto@amacapital.net>
> >
> > commit 554086d85e71f30abe46fc014fea31929a7c6a8a upstream.
> >
> > The bad syscall nr paths are their own incomprehensible route
> > [...]
> 
> Don't apply this without:
> 
> https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?h=x86/urgent&id=8142b215501f8b291a108a202b3a053a265b03dd
> 
> Sorry!

No worries -- I've dropped this from the 3.8-stable queue, pending . . .

> As that isn't in Linus's tree yet, don't apply that one either...
> thanks,
> greg k-h

. . . that.  Thanks Andy and Greg,

 -Kamal


