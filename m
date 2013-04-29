Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab3D2ILT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 04:11:19 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:34466 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab3D2ILR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 04:11:17 -0400
Message-ID: <517E2B21.8070009@intel.com>
Date: Mon, 29 Apr 2013 09:11:13 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: linux-next: Tree for Apr 26
References: <20130426180357.7599d1b6b7965470905dcdf3@canb.auug.org.au> <CAMuHMdWQ0rMuoH+peGMZ3=AdsYrMPpeV4_vSsLD3kaJukx=83w@mail.gmail.com> <20130429093628.b739ef3b879b6f8759bd31af@canb.auug.org.au>
In-Reply-To: <20130429093628.b739ef3b879b6f8759bd31af@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/04/13 00:36, Stephen Rothwell wrote:
> Commit e29c2de5f591 ("Merge tag 'v3.9-rc8' into efi-for-tip") by Matt
> Fleming from the tip tree merged v3.9-rc8 (which has 0635eb8a54cf) with
> the branch that contains 048517722cde but lost the "select UCS2_STRING"
> which should be in drivers/firmware/efi/Kconfig.

Eek, yes. Sorry about that. How should we resolve this?
