Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab3GJWOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 18:14:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42034 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447Ab3GJWOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 18:14:34 -0400
Date: Thu, 11 Jul 2013 00:14:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        Borislav Petkov <bpetkov@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 1/2 v2] x86: introduce int3-based instruction
 patching
Message-ID: <20130710221417.GD9140@pd.tnic>
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>
 <alpine.LNX.2.00.1307102218200.25858@pobox.suse.cz>
 <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz>
 <51DDD3E9.6090601@linux.intel.com>
 <20130710214848.GB14879@pd.tnic>
 <51DDD894.3050408@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51DDD894.3050408@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 02:56:36PM -0700, H. Peter Anvin wrote:
> No, the idea is that the affected CPU will simply execute int3 -> iret
> ad nauseam until the first byte is repatched, at that point execution
> will resume normally.

Ok, that sounds simple enough. I just hope we don't unearth some silly
cross-modifying code snafus in some CPUs with it. :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
