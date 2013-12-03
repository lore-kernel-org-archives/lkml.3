Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab3LCRBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:01:55 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47321 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381Ab3LCRBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:01:52 -0500
Date: Tue, 3 Dec 2013 18:01:50 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: Levente Kurusa <levex@linux.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        EDAC <linux-edac@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mcheck: call put_device on device_register failure
Message-ID: <20131203170150.GA5369@pd.tnic>
References: <5298F900.9000208@linux.com>
 <20131129205628.GA20144@pd.tnic>
 <52999419.7040600@linux.com>
 <20131130111214.GB4323@pd.tnic>
 <20131203022330.GA25136@gchen.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131203022330.GA25136@gchen.bj.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you please fix your

Mail-Followup-To:

header? It is impossible to reply to your emails without fiddling with
the To: and Cc: by hand which gets very annoying over time.

On Mon, Dec 02, 2013 at 09:23:30PM -0500, Chen, Gong wrote:
> I have some concerns about it. if device_register is failed, it will
> backtraces all kinds of conditions automatically, including put_device
> definately. So do we really need an extra put_device when it returns
> failure?

Do you mean the "done:" label in device_add() which does put_device()
and which gets called by device_register()?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
