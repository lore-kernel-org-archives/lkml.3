Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbaFRP1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:27:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39562 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbaFRP1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:27:14 -0400
Date: Wed, 18 Jun 2014 17:27:10 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Qiaowei Ren <qiaowei.ren@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 03/10] x86, mpx: add macro cpu_has_mpx
Message-ID: <20140618152710.GF24024@pd.tnic>
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com>
 <1403084656-27284-4-git-send-email-qiaowei.ren@intel.com>
 <20140618095739.GA24419@pd.tnic>
 <53A1A3A5.9010109@intel.com>
 <20140618144429.GD24024@pd.tnic>
 <53A1A98D.8050408@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53A1A98D.8050408@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 08:00:29AM -0700, H. Peter Anvin wrote:
> We have people working hard to shave kilobytes off the smallest
> configurations, because they want to fit into a megabyte of memory
> with the kernel and application.
>
> Let's try to not make their life harder than it needs to be.

Oh sure - I'm simply asking how this is going to be handled practically
by asking stupid questions. You know me :)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
