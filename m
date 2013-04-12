Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab3DLI4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 04:56:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58822 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab3DLI4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 04:56:13 -0400
Message-ID: <5167CC2B.7070005@suse.de>
Date: Fri, 12 Apr 2013 10:56:11 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Neela Syam Kolli <megaraidlinux@lsi.com>,
        viro@ZenIV.linux.org.uk,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 18/26] megaraid: Don't use create_proc_read_entry() [RFC]
References: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk> <20130411133001.32763.78829.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130411133001.32763.78829.stgit@warthog.procyon.org.uk>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 03:30 PM, David Howells wrote:
> Don't use create_proc_read_entry() as that is deprecated, but rather use
> proc_create_data() and seq_file instead.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Neela Syam Kolli <megaraidlinux@lsi.com>
> cc: James E.J. Bottomley <JBottomley@parallels.com>
> cc: linux-scsi@vger.kernel.org

Hmm?
What is the general stance on /proc entries for devices?
I was under the impression that it was marked as deprecated.

Is it not? Has it been resurrected?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
