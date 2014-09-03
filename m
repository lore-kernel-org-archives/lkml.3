Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935365AbaICXJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:09:04 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:34975 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935352AbaICXI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 19:08:59 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:8:ee7:b1d3:270e:d486:bce3]
In-Reply-To: <20140902232906.GG29327@sirena.org.uk>
References: <1397743910-18391-1-git-send-email-pefoley2@pefoley.com>
 <53FB9DA0.7000301@infradead.org> <CAOFdcFP4b0YFMuUFKm4=FoAGbCObf4u=W0UUPwf-ju_TNvuJaA@mail.gmail.com>
 <540651B3.8030400@infradead.org> <20140902232906.GG29327@sirena.org.uk>
From: Peter Foley <pefoley2@pefoley.com>
Date: Wed, 3 Sep 2014 19:08:38 -0400
Message-ID: <CAOFdcFPmHH9z+6Kuc5Agu6PDC9+t+420Cb5R6VuHp+MebG+2LQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] Documentation: use subdir-y to avoid unnecessary
 built-in.o files
To: Mark Brown <broonie@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014 at 7:29 PM, Mark Brown <broonie@kernel.org> wrote:
> Your tree either wasn't in the control file that Stephen handed off or
> got eaten by one off his scripts for some reason.  I've tried adding it
> back, we'll see if that works tomorrow.

The patches still seem to be missing from the 20140903 -next tree,
unfortunately.
