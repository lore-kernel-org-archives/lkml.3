Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab3GIOjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 10:39:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56804 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab3GIOjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 10:39:39 -0400
MIME-Version: 1.0
In-Reply-To: <s5hfvvng8py.wl%tiwai@suse.de>
References: <20130702192749.A2E7E660D9B@gitolite.kernel.org>
	<20130706221401.GA3652@redhat.com>
	<20130706223003.GA10697@kroah.com>
	<s5h4nc5bewf.wl%tiwai@suse.de>
	<CACVXFVN452nktR=JTTubnYwVkcDdoued0VysT1vA+2jHU1A3Gw@mail.gmail.com>
	<s5hmwpwuwjp.wl%tiwai@suse.de>
	<CACVXFVNx7SA3rM46q4=7+7QU==EL3ukAeWcaBYruykfE6JPe8w@mail.gmail.com>
	<s5hfvvng8py.wl%tiwai@suse.de>
Date: Tue, 9 Jul 2013 22:39:36 +0800
Message-ID: <CACVXFVN-Qt8PP1YspX_M8H1W_-9Q-f8u1xPKcsqSWsqZqkhVyw@mail.gmail.com>
Subject: Re: dell_rbu: Select CONFIG_FW_LOADER_USER_HELPER explicitly
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Greg KH <gregkh@linuxfoundation.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 9, 2013 at 9:32 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Tue, 9 Jul 2013 16:43:30 +0800,
>> Actually from view of distribution, dell rbu has to be compiled in, then
>> no code size can be saved any more, which means looks the introduced
>> option in this patch isn't necessary.
>
> Well, but it means that there is no way not to compile user-helper
> mode code in firmware_class.c.  In other words, in which condition,
> request_firmware_user() will be compiled?

It can be always compiled in. Basically dell rbu is always enabled in
distributions, which means the user helper code has to be compiled in.

Thanks,
--
Ming Lei
