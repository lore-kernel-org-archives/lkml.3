Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762820Ab3JQVNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:13:17 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:65273 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762289Ab3JQVNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:13:14 -0400
Date: Thu, 17 Oct 2013 17:11:43 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arend van Spriel <arend@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: trace-cmd problem with FC19
Message-ID: <20131017211143.GA29276@localhost>
References: <525FD328.1040204@broadcom.com>
 <20131017144116.044f3aaf@gandalf.local.home>
 <52604373.5010907@broadcom.com>
 <20131017162029.002485b1@gandalf.local.home>
 <CAEKwDSAucy8NziB=mcem7we9vnGHe=cWt-4Q1X7+Vt5dokY19A@mail.gmail.com>
 <20131017165656.54b8b985@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017165656.54b8b985@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 04:56:56PM -0400, Steven Rostedt wrote:
> Hmm, are you sure?
> 
> You may want to do both:
> 
> sudo trace-cmd -v
> which trace-cmd
> 
> to see which version it is.

To clarify - I ran into the referenced issue using an older,
self-compiled version with a recent kernel.  The FC19 distro
version may be fine, for all I know.

Arend says he used the latest version from the repo which should
not be a problem, but just throwing that out there since the
symptoms are similar.

-- 
Bob Copeland %% www.bobcopeland.com
