Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab3GWMYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 08:24:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35566 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757201Ab3GWMX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 08:23:59 -0400
Date: Tue, 23 Jul 2013 14:23:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]Fix early microcode loading on AMD
Message-ID: <20130723122354.GD8497@pd.tnic>
References: <20130723135853.579c3cd5@googlemail.com>
 <51EE70D4.1030706@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51EE70D4.1030706@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 05:02:28AM -0700, H. Peter Anvin wrote:
> Borislav, do you agree with these patches?  (This one and the errata
> check?)  If so I will queue them up in x86/urgent.

I was just about to have another look at the whole deal. Give me a
couple of days - I'll let you know.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
