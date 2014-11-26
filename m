Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbaKZOiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:38:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbaKZOiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:38:17 -0500
Message-ID: <1417012696.5928.12.camel@linux-0dmf.site>
Subject: Re: bluetooth related firmware loader spew on resume.
From: Oliver Neukum <oneukum@suse.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Marcel Holtmann <marcel@holtmann.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, pgynther@google.com,
        linux-bluetooth@vger.kernel.org
Date: Wed, 26 Nov 2014 15:38:16 +0100
In-Reply-To: <s5hr3wqvxr6.wl-tiwai@suse.de>
References: <20141111181228.GA27815@redhat.com>
	 <s5hsih7xmgg.wl-tiwai@suse.de>
	 <D19A9DA1-3706-4351-B2E9-25D5ABA662E7@holtmann.org>
	 <s5h7fyijqc9.wl-tiwai@suse.de> <1416996623.3171.7.camel@linux-0dmf.site>
	 <s5hlhmyxng0.wl-tiwai@suse.de> <1416998616.3171.13.camel@linux-0dmf.site>
	 <s5hioi2xmf9.wl-tiwai@suse.de> <1417011800.5928.9.camel@linux-0dmf.site>
	 <s5hr3wqvxr6.wl-tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-26 at 15:31 +0100, Takashi Iwai wrote:

> Yes, that's what I mentioned in my reply.  But, actually more puzzling
> is that the WARNING shouldn't have been triggered at all.  That is,
> something is still racy there, so we'd need to fix it.

Did it trigger before khubd was replaced by a work queue?

	Regards
		Oliver


