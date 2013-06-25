Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab3FYVtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:49:18 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60092 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3FYVtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:49:17 -0400
Date: Tue, 25 Jun 2013 22:49:14 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Yves-Alexis Perez <corsac@debian.org>
Cc: linux-acpi@vger.kernel.org, seth.forshee@canonical.com,
        joeyli.kernel@gmail.com, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org, rjw@sisk.pl,
        Henrique de Moraes Holschuh <hmh@debian.org>
Subject: Re: [PATCH 0/3] Fix backlight issues on some Windows 8 systems
Message-ID: <20130625214914.GA3654@srcf.ucam.org>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
 <1371937599.17761.19.camel@scapa>
 <20130625160848.GA27123@srcf.ucam.org>
 <1372193037.8189.24.camel@scapa>
 <20130625205430.GA2438@srcf.ucam.org>
 <1372194611.8189.31.camel@scapa>
 <20130625211415.GA2899@srcf.ucam.org>
 <1372195837.8189.42.camel@scapa>
 <20130625213300.GA3296@srcf.ucam.org>
 <1372196761.8189.47.camel@scapa>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1372196761.8189.47.camel@scapa>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 11:46:01PM +0200, Yves-Alexis Perez wrote:
> But if that introduce regressions, shouldn't workarounds be found then?
> Sorry if I keep repeating that but brightness keys handling in-kernel is
> quite a useful feature and losing it (because of the “behave exactly
> like Windows 8 kernel” policy) is indeed a regression.

Your firmware behaves differently depending on whether the OS claims to 
be Windows 8 or not. We can't make that invisible.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
