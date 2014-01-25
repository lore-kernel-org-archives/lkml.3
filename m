Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284AbaAYDX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 22:23:57 -0500
Received: from linuxhacker.ru ([217.76.32.60]:52660 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaAYDX4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 22:23:56 -0500
Subject: Re: [PATCH 5/5] lustre: add myself to list of people to CC on lustre patches
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Oleg Drokin <green@linuxhacker.ru>
In-Reply-To: <CAMuHMdWXvyTpoafetr63-80GWppZGC3y72otuf89d3LJoKwXOQ@mail.gmail.com>
Date: Fri, 24 Jan 2014 22:23:09 -0500
Cc: Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Christoph Hellwig <hch@infradead.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <AB57D4F6-7E01-43E6-A421-F73BE52AB74C@linuxhacker.ru>
References: <1390538708-4120-1-git-send-email-green@linuxhacker.ru> <1390538708-4120-6-git-send-email-green@linuxhacker.ru> <1390542276.32356.22.camel@joe-AO722> <8ADC515E-0EB5-4891-A6C9-CEAEA5E50E34@linuxhacker.ru> <CAMuHMdWXvyTpoafetr63-80GWppZGC3y72otuf89d3LJoKwXOQ@mail.gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Jan 24, 2014, at 3:55 AM, Geert Uytterhoeven wrote:

> On Fri, Jan 24, 2014 at 6:51 AM, Oleg Drokin <green@linuxhacker.ru> wrote:
>>> +STAGING - LUSTRE
>>> +M:   Andreas Dilger <andreas.dilger@intel.com>
>>> +M:   Oleg Drokin <oleg.drokin@intel.com>
>>> +M:   Peng Tao <tao.peng@emc.com>.
>>> +L:   hpdd-discuss <hpdd-discuss@lists.01.org>
>>> +S:   Odd Fixes
>> 
>> Actually we are at least Maintained here, if not outright Supported.
> 
> Good to hear that!
> So can we assume that https://lkml.org/lkml/2013/9/9/725 will be fixed
> shortly,

We are working on it.

> and http://kisskb.ellerman.id.au/kisskb/buildresult/10508264/
> will turn green again?

I certainly hope so.
BTW, do you also provide interface where I can drop in my patch and your builder verify it for me by any chance,
so that I don't need to replicate build environment for every supported architecture?

Thanks.

Bye,
    Oleg