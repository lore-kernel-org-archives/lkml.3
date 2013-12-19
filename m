Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab3LSLTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:19:00 -0500
Received: from mga01.intel.com ([192.55.52.88]:1061 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab3LSLSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:18:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,512,1384329600"; 
   d="scan'208";a="446905055"
Date: Thu, 19 Dec 2013 13:18:48 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Sergei Ianovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Grant Likely <grant.likely@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        James Cameron <quozl@laptop.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH v3 12/21] serial: support for 16550A serial ports on
 LP-8x4x
Message-ID: <20131219111848.GD20686@xps8300>
References: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
 <1387309071-22382-1-git-send-email-ynvich@gmail.com>
 <1387309071-22382-13-git-send-email-ynvich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387309071-22382-13-git-send-email-ynvich@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Dec 17, 2013 at 11:37:42PM +0400, Sergei Ianovich wrote:
> The patch adds support for 3 additional LP-8x4x built-in serial
> ports.
> 
> The device can also host up to 8 extension cards with 4 serial ports
> on each card for a total of 35 ports. However, I don't have
> the hardware to test extension cards, so they are not supported, yet.
> 
> Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
> CC: Heikki Krogerus <heikki.krogerus@linux.intel.com>

Looks OK to me, though normally I would prefer the arch code and the
driver to be handled in separate patches. FWIW...

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>


Thanks,

-- 
heikki
