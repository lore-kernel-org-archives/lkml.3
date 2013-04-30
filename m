Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760349Ab3D3Lgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 07:36:33 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:22582 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760270Ab3D3Lgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 07:36:32 -0400
Date: Tue, 30 Apr 2013 13:36:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: Re: Kconfig "softdepends" idea
Message-ID: <20130430113625.GA15645@merkur.ravnborg.org>
References: <517F9472.2030106@ti.com> <20130430102440.GA15522@merkur.ravnborg.org> <20130430103318.GB12161@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430103318.GB12161@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 01:33:18PM +0300, Felipe Balbi wrote:
> 
> I think something like 'available on ARCH_OMAP' might be useful,
> however.

In general I try to avoid extending the Kconfig language.
Let's try to keep it simple.

So as long as we can do it within the current language let's not invent
something new.

	Sam
