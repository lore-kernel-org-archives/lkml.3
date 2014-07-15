Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030368AbaGOXoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:44:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34080 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933812AbaGOXoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:44:16 -0400
Date: Wed, 16 Jul 2014 01:44:14 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: David Rientjes <rientjes@google.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, tglx@linutronix.de,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] x86, platform, xen, kconfig: move kvmconfig
	functionality to a helper
Message-ID: <20140715234414.GL10393@wotan.suse.de>
References: <1402338984-9774-1-git-send-email-mcgrof@do-not-panic.com> <alpine.DEB.2.02.1406091401080.30620@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1406091401080.30620@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 02:01:42PM -0700, David Rientjes wrote:
> On Mon, 9 Jun 2014, Luis R. Rodriguez wrote:
> 
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > 
> > This can then be used by other virtual configs.
> > 
> > Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> 
> Suggested-by: David Rientjes <rientjes@google.com>
> Acked-by: David Rientjes <rientjes@google.com>

Folks this series is not yet merged. They all apply cleanly
as-is on linux-next next-20140715 so I don't think a resend
is required.

Just a friendly reminder.

  Luis
