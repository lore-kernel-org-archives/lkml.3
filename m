Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab3DPMNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 08:13:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44488 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757120Ab3DPMNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 08:13:20 -0400
Date: Tue, 16 Apr 2013 13:12:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Girish KS <girishks2000@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, t.figa@samsung.com
Subject: Re: [PATCH V4 2/5] spi: s3c64xx: added support for polling mode
Message-ID: <20130416121255.GA15878@sirena.org.uk>
References: <1366015230-18243-1-git-send-email-ks.giri@samsung.com>
 <20130416112035.GD26958@opensource.wolfsonmicro.com>
 <CAKrE-Kd4Vis0-V_n8zEzqJVBbEYvTiYS8hY_7s7AnUqaK2tFCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKrE-Kd4Vis0-V_n8zEzqJVBbEYvTiYS8hY_7s7AnUqaK2tFCQ@mail.gmail.com>
X-Cookie: When in doubt, follow your heart.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 04:58:47PM +0530, Girish KS wrote:
> On Tue, Apr 16, 2013 at 4:50 PM, Mark Brown <broonie@kernel.org> wrote:

> > I'm missing patch 1 of this series.

> its already  merged to stable tree after your review

The patch numbering should reflect what you're posting.  If you're only
sending four patches they should be numbered 1-4, otherwise it looks
like there's something missing.  The goal with the numbers is to help
people get the patches in the right order, the name should be enough to
associate with other versions of the same patch.
