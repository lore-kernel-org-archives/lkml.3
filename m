Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbbA1AyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 19:54:16 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:47539 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbbA1AyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 19:54:13 -0500
MIME-Version: 1.0
In-Reply-To: <CA+8MBbLVgfk3LEAnuAx_MRJpHkQO-cEQnuCrcbxcyOezr5RLcg@mail.gmail.com>
References: <20150123203145.GA6691@google.com>
	<CA+8MBbKnT=mE3kev8BRPq0GeTgHx8WVa6o54tJuBX_XXLpHdYQ@mail.gmail.com>
	<CAErSpo7y1wWStjcEOH9xTiM-As8+QeMynZ5ENrL9v3X2PvQCcw@mail.gmail.com>
	<CA+8MBb+bWiX2eayjBQHsvCjTp3t8H9=AviF9AkV6CC--cC_fYQ@mail.gmail.com>
	<CAE9FiQXj07CtOJ6uBZomNyhAH9ANanbbUSo51td6G-UB5Rmmow@mail.gmail.com>
	<CA+8MBbLVgfk3LEAnuAx_MRJpHkQO-cEQnuCrcbxcyOezr5RLcg@mail.gmail.com>
Date: Tue, 27 Jan 2015 16:54:07 -0800
X-Google-Sender-Auth: dYl-9bZ4bCP8Em7gtfQq0jklC9A
Message-ID: <CAE9FiQXnTPO2tM252zvTGJF9Nmc-R+6z65Kq3aXC3jvxtAK2Qw@mail.gmail.com>
Subject: Re: [GIT PULL] PCI fixes for v3.19
From: Yinghai Lu <yinghai@kernel.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Richard Zhu <Richard.Zhu@freescale.com>,
        Marek Kordik <kordikmarek@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andreas Hartmann <andihartmann@freenet.de>,
        Alexey Voronkov <zermond@gmail.com>, David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 3:24 PM, Tony Luck <tony.luck@gmail.com> wrote:
> On Mon, Jan 26, 2015 at 7:43 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> Can you please get boot bog with "debug ignore_logleve"?
>>
>> we should get print out from
>>
>> +               dev_printk(KERN_DEBUG, &dev->dev, "%pR clipped to %pR\n",
>> +                                &orig_res, res);
>
> Attached ... but I don't see any "clipped" messages

Good. so the system should just work as before but have annoying warnings.

Do we need to put the paper back to hide the warning?

Thanks

Yinghai
