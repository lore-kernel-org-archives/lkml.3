Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab3GIPWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:22:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57049 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3GIPWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:22:36 -0400
MIME-Version: 1.0
In-Reply-To: <s5h1u77g41f.wl%tiwai@suse.de>
References: <20130702192749.A2E7E660D9B@gitolite.kernel.org>
	<20130706221401.GA3652@redhat.com>
	<20130706223003.GA10697@kroah.com>
	<s5h4nc5bewf.wl%tiwai@suse.de>
	<CACVXFVN452nktR=JTTubnYwVkcDdoued0VysT1vA+2jHU1A3Gw@mail.gmail.com>
	<s5hmwpwuwjp.wl%tiwai@suse.de>
	<CACVXFVNx7SA3rM46q4=7+7QU==EL3ukAeWcaBYruykfE6JPe8w@mail.gmail.com>
	<s5hfvvng8py.wl%tiwai@suse.de>
	<CACVXFVN-Qt8PP1YspX_M8H1W_-9Q-f8u1xPKcsqSWsqZqkhVyw@mail.gmail.com>
	<s5h4nc3g5cg.wl%tiwai@suse.de>
	<CACVXFVPtAJUOH5v_i_xVkt9QoKN8wVdyJ=W+M87ASbBmHtz9rg@mail.gmail.com>
	<s5h1u77g41f.wl%tiwai@suse.de>
Date: Tue, 9 Jul 2013 23:22:33 +0800
Message-ID: <CACVXFVPGeqvL-P8kXAg00bvWYbMK9N0OpRVbesuNgNEmVPJdSA@mail.gmail.com>
Subject: Re: dell_rbu: Select CONFIG_FW_LOADER_USER_HELPER explicitly
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Greg KH <gregkh@linuxfoundation.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 9, 2013 at 11:13 PM, Takashi Iwai <tiwai@suse.de> wrote:
>>
>> The only cost of built-in user helper code is ~6Kbytes code on my armv7
>> box.
>>
>> If the 6KB memory does mater for this non-distro kernel, we can introduce
>> more options.
>
> Well, if it doesn't matter, we don't need CONFIG_FW_LOADER_USER_HELPER
> either.  The goal of this option is to kill the user helper code, not
> intended as a workaround for 60 seconds stall.

Actually, the Kconfig help is "Fallback user-helper invocation for
firmware loading",
so looks the description in help doc isn't consistent with what you wanted, :-)


Thanks,
--
Ming Lei
