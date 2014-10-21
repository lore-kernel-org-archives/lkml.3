Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbaJUIqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:46:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45257 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbaJUIql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:46:41 -0400
Date: Tue, 21 Oct 2014 10:46:38 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Guenter Roeck <linux@roeck-us.net>
cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH v2 31/47] x86: apm: Register with kernel poweroff
 handler
In-Reply-To: <1413864783-3271-32-git-send-email-linux@roeck-us.net>
Message-ID: <alpine.LNX.2.00.1410211045530.24255@pobox.suse.cz>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net> <1413864783-3271-32-git-send-email-linux@roeck-us.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2014, Guenter Roeck wrote:

> Register with kernel poweroff handler instead of setting pm_power_off
> directly. Register with high priority to reflect that the original code
> overwrites existing poweroff handlers.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

For this one:

	Reviewed-by: Jiri Kosina <jkosina@suse.cz>

-- 
Jiri Kosina
SUSE Labs
