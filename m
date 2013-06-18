Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab3FRJAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:00:52 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35591 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001Ab3FRJAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:00:49 -0400
Date: Tue, 18 Jun 2013 11:00:45 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, mchehab@redhat.com,
        norsk5@xmission.com
Subject: Re: EDAC BUG: key ee78135c not in .data!
Message-ID: <20130618090044.GB13123@pd.tnic>
References: <20130618011145.GB2200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130618011145.GB2200@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 09:11:45PM -0400, Dave Jones wrote:
> I see this during boot-up:
> 
> 
> i5k_amb: probe of i5k_amb.0 failed with error -16
> EDAC MC: Ver: 3.0.0
> BUG: key ee78135c not in .data!
> ------------[ cut here ]------------
> WARNING: at kernel/lockdep.c:2987 lockdep_init_map+0x34f/0x37c()

http://marc.info/?l=linux-kernel&m=136837305611163&w=2

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
