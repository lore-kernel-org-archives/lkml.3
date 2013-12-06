Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab3LFSnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:43:40 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:53831 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3LFSni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:43:38 -0500
MIME-Version: 1.0
In-Reply-To: <20131206183930.GC4379@kroah.com>
References: <CA+5PVA6Mh=tRM5h=TCbg5yjkkFUg2OncJmHBdtBhG7jqf377rg@mail.gmail.com>
	<CA+5PVA4pXtXHWzeSnx7d9eGEiOQ-jtL2RtBEyqxmz2DemT--jw@mail.gmail.com>
	<20131206183930.GC4379@kroah.com>
Date: Fri, 6 Dec 2013 13:43:38 -0500
X-Google-Sender-Auth: ycPs44oNstCAtb-Ag0nfBYUYWk0
Message-ID: <CA+5PVA7_iLoeJseApkeTcjch=ONU+ebUPk4G+oUy62mmp2RCTA@mail.gmail.com>
Subject: Re: Nov. Fedora Kernel Patch Report
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Greg KH <greg@kroah.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kernel Fedora <kernel@lists.fedoraproject.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 6, 2013 at 1:39 PM, Greg KH <greg@kroah.com> wrote:
> On Mon, Dec 02, 2013 at 06:56:24PM -0500, Josh Boyer wrote:
>> > drm-radeon-24hz-audio-fixes.patch (rhbz 1010679)
>> > - Should be in 3.13
>>
>> Commits 908171aa738b5bbcc6241cec46f73fcd57dd00d4 and
>> 05e4776357fe7217e531cbaaa163e24f688d10ce
>
> These commits don't match anything in Linus's tree, are you sure they
> are correct?

Sorry, they aren't.  Here are the commits from Linus' tree:

a2098250fbda149cfad9e626afe80abe3b21e574 drm/radeon/audio: improve ACR
calculation
3e71985f2439d8c4090dc2820e497e6f3d72dcff drm/radeon/audio: correct ACR table

josh
