Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab3EUWwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 18:52:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59519 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab3EUWwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 18:52:16 -0400
Date: Tue, 21 May 2013 15:52:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kexec-list (kexec@lists.infradead.org)" <kexec@lists.infradead.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "kay@vrfy.org" <kay@vrfy.org>, "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Subject: Re: [PATCH]Add kmsg_dump() to kexec path
Message-Id: <20130521155214.ecb11fad387da06eba3bb73b@linux-foundation.org>
In-Reply-To: <20130521224741.GA5707@kroah.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41AFEF289@USINDEM103.corp.hds.com>
	<20130521154137.0db53981578ee206b21850f9@linux-foundation.org>
	<20130521224741.GA5707@kroah.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 May 2013 15:47:41 -0700 "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org> wrote:

> On Tue, May 21, 2013 at 03:41:37PM -0700, Andrew Morton wrote:
> > Guys, can we please get some review attention to this?
> 
> I thought it was reviewed, and rejected, already.  Did you miss those
> emails?

I had memories of the same thing, but can't find any record in lkml
archives.  Either we're thinking of a different patch or this one has
appeared under multiple titles.

