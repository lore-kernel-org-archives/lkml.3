Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab3LUObo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 09:31:44 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53096 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab3LUObn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 09:31:43 -0500
Date: Sat, 21 Dec 2013 14:31:12 +0000
From: Mark Brown <broonie@kernel.org>
To: Levente Kurusa <levex@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Message-ID: <20131221143112.GI30815@sirena.org.uk>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
 <1387465429-3568-24-git-send-email-levex@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387465429-3568-24-git-send-email-levex@linux.com>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 217.42.81.147
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 23/38] sound: soc: add missing put_device call
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 04:03:34PM +0100, Levente Kurusa wrote:
> This is required so that we give up the last reference to the device.

Applied, thanks.  Please use subject lines matching the standard for the
subsystem.
