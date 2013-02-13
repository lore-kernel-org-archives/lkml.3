Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab3BMS1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:27:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51800 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab3BMS1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:27:39 -0500
Date: Wed, 13 Feb 2013 19:27:30 +0100
From: Borislav Petkov <bp@alien8.de>
To: Du Jiulun <dujiulun@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hillf Danton <dhillf@gmail.com>, Mike Galbraith <bitbucket@online.de>
Subject: Re: Fwd: PROBLEM: Random kernel panic & system freeze when watching
 video
Message-ID: <20130213182730.GB18013@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Du Jiulun <dujiulun@gmail.com>, "Luck, Tony" <tony.luck@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Hillf Danton <dhillf@gmail.com>,
	Mike Galbraith <bitbucket@online.de>
References: <CAHfmSg3ug=64vXtsA4EA6xdKaqWRtT7qZW9AG8n92Q+pbDgQEQ@mail.gmail.com>
 <20121230094008.GA28308@x1.alien8.de>
 <CAHfmSg0O90nC3rnkZHAjO_MNjOoU1v8h-LN+jxx=0U+pz7NasQ@mail.gmail.com>
 <20121231102300.GA1701@x1.alien8.de>
 <3908561D78D1C84285E8C5FCA982C28F1C973871@ORSMSX108.amr.corp.intel.com>
 <CAHfmSg14itHxTUinrmmTq2zoFuQAVwhPCo-Mt7tTLJEiJ4B0Sw@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F1C973F99@ORSMSX108.amr.corp.intel.com>
 <CAHfmSg3-YthwNUTCmbEQox5ihjYHw9TT=WaH_fbjHHyJ+ew7eA@mail.gmail.com>
 <CAHfmSg0sxOEvLd9ASHA7uS+W2TiZ-NRR+w8snPu85iYrMFCuVA@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F1E0628AD@ORSMSX108.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1E0628AD@ORSMSX108.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 06:11:30PM +0000, Luck, Tony wrote:
> > -- Panic DON'T happen when the laptop is running on battery. I've
> > tried over 20 battery cycles (~40 hours) doing video playbacks and the
> > computer never shut down.
> 
> So my best guess is that you have a h/w problem aggravated by high temperatures.
> When you are on battery the system will be saving power - which means less heat
> dissipated by many components inside your laptop case.

One thing we haven't asked is whether you still have the warranty on
your hardware, and, if so, why not send it to the manufacturer so that
they can take a look at it - they should be much better than us software
guys and have the right tools for hardware inspection.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
