Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933677Ab3EGOED (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:04:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35951 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933094Ab3EGOD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:03:59 -0400
Date: Tue, 7 May 2013 16:04:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: WARNING: at kernel/cpu/idle.c:96
Message-ID: <20130507140413.GB7678@pd.tnic>
References: <20130430155203.GA512@x4>
 <alpine.LFD.2.02.1305021242180.3972@ionos>
 <20130502113011.GA508@x4>
 <alpine.LFD.2.02.1305021557030.3972@ionos>
 <20130502140654.GA509@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130502140654.GA509@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 04:06:54PM +0200, Markus Trippelsdorf wrote:
> > Moo. I missed amd_e400_idle() returning early w/o enabling interrupts.
> 
> This fixes the issue. Thanks.

Ditto.

Tested-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
