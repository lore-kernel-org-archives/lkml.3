Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaKKWca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 17:32:30 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:57881 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaKKWc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 17:32:29 -0500
Date: Tue, 11 Nov 2014 22:32:24 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Mathias Krause <minipli@googlemail.com>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86-ml <x86@kernel.org>, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCHv2 1/3] x86, ptdump: Add section for EFI runtime services
Message-ID: <20141111223224.GL1292@console-pimps.org>
References: <20141007150132.GA7307@nazgul.tnic>
 <20141007170748.GA25767@jig.fritz.box>
 <20141008151730.GB16892@pd.tnic>
 <CA+rthh_Q0HQfLX6P3kcuOUwggjSnhYGCc5YJNOn0UCCRPZbaxA@mail.gmail.com>
 <20141008222619.GG16892@pd.tnic>
 <20141012125515.GA32045@jig.fritz.box>
 <20141028185756.GD10873@pd.tnic>
 <CA+rthh9qePkJogFDT+ttSLvYPvJrAM6CXMJ407Hq3PjcRw9WTw@mail.gmail.com>
 <20141029142214.GS12020@console-pimps.org>
 <CA+rthh_z4i8=fk-xOh75tJrXVnG36hTeUkX8bRrmNT+WF2RuWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+rthh_z4i8=fk-xOh75tJrXVnG36hTeUkX8bRrmNT+WF2RuWA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov, at 10:59:07PM, Mathias Krause wrote:
> 
> Matt, do you mind to take this patch (and only this patch) through the EFI tree?
> There were objections to patch 2 and 3 of this series from the x86
> folks so I won't re-do those.

Applied with Borislav's ACK, thanks Mathias.

-- 
Matt Fleming, Intel Open Source Technology Center
