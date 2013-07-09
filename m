Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab3GIHrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:47:21 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:50156 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab3GIHrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 03:47:19 -0400
MIME-Version: 1.0
In-Reply-To: <51DBBD3A.3020200@free-electrons.com>
References: <1373263451-26841-1-git-send-email-michael.opdenacker@free-electrons.com>
	<CAMuHMdVm_G6GuMnROosQb94rk3fokiOaz70T-HZ79amV3Cyx4A@mail.gmail.com>
	<51DBBD3A.3020200@free-electrons.com>
Date: Tue, 9 Jul 2013 09:47:19 +0200
X-Google-Sender-Auth: dlx1X7aQUwxEgQOIADhN0xlTZmQ
Message-ID: <CAMuHMdVZaW3=ZBot-RvuyCa94H0HSOwboOA8aBNPSdqkvcG=pA@mail.gmail.com>
Subject: Re: [PATCH 0/3] cris: cleanup Kconfig files
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Woodhouse, David" <David.Woodhouse@intel.com>,
        artem.bityutskiy@linux.intel.com, Cris <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Bolle <pebolle@tiscali.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 9, 2013 at 9:35 AM, Michael Opdenacker
<michael.opdenacker@free-electrons.com> wrote:
> On 07/09/2013 09:33 AM, Geert Uytterhoeven wrote:
>> On Mon, Jul 8, 2013 at 8:04 AM, Michael Opdenacker
>> <michael.opdenacker@free-electrons.com> wrote:
>>> This set of patches removes kernel configuration parameters for the
>>> CRIS architecture, which are used nowhere in the kernel source
>>> code and makefiles.
>>>
>> (At least) Some of these have been in cris/for-next for a few months,
>> courtesy of
>> Paul Bolle.
>
> Thank you for your reply. I hope they will make it this time.

/me too

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
