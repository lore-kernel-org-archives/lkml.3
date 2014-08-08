Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbaHHQjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:39:04 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:28457 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756558AbaHHQjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:39:02 -0400
Message-ID: <1407515940.31897.31.camel@hornet>
Subject: Re: [PATCH 2/5] char: tile-srom: Remove reference to platform_bus
From: Pawel Moll <pawel.moll@arm.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "paul@pwsan.com" <paul@pwsan.com>, Arnd Bergmann <arnd@arndb.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 08 Aug 2014 17:39:00 +0100
In-Reply-To: <1407515691.31897.26.camel@hornet>
References: <1406298233-27876-1-git-send-email-pawel.moll@arm.com>
	 <1406298233-27876-2-git-send-email-pawel.moll@arm.com>
	 <53DAA605.2030500@tilera.com> <1406913678.22529.46.camel@hornet>
	 <53E139C8.9000502@tilera.com> <1407515691.31897.26.camel@hornet>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-08 at 17:34 +0100, Pawel Moll wrote:
> On Tue, 2014-08-05 at 21:08 +0100, Chris Metcalf wrote:
> > >> In addition, we also have user binaries
> > >> in the wild that know to look for /sys/devices/platform/srom/ paths,
> > >> so I'm pretty reluctant to change this path without good reason.
> > > So what is the srom class for then if not for device discovery? And why
> > > do they look for them in the first place? To get relevant character
> > > device's data, if I understand it right?
> > >
> > > Maybe you could just register a simple "proper" platform device for all
> > > the sroms and then hang the class devices from it? I can type some code
> > > doing this if it sound reasonably?
> > 
> > I'm not sure exactly what you mean by device discovery here.  

(sorry, sent too early...)

By "device discovery" I meant the way you find the way in your devices
in /sysfs. You seem to be traversing /sys/devices/... tree, while you've
got almost direct access to them through /sys/class/srom and you can (I
believe, correct me if I'm wrong, Greg) rely on this path being stable.

Paweł

