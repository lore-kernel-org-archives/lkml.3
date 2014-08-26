Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaHZRO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 13:14:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbaHZRO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 13:14:27 -0400
Date: Tue, 26 Aug 2014 19:14:25 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Abhay Salunke <abhay_salunke@dell.com>
Cc: Tom Gundersen <teg@jklm.no>, crrodriguez@opensuse.org,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        systemd-devel@lists.freedesktop.org,
        Mario Limonciello <mario_limonciello@dell.com>
Subject: Re: dell rbu driver and FW_LOADER_USER_HELPER
Message-ID: <20140826171425.GQ3347@wotan.suse.de>
References: <20140826170946.GP3347@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140826170946.GP3347@wotan.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 07:09:46PM +0200, Luis R. Rodriguez wrote:
> When Christian tried removing the udev firmware loader
> it was detected that the Dell rbu driver still required
> use of FW_LOADER_USER_HELPER [0]. This driver needed
> reworking to not be tied to the firmware loader, curious
> if anyone has been working on that. Is the current
> implementation depending on that userspace identifies
> the required path to the file ? Why can't standard
> /lib/firmware/ paths be used ?
> 
> [0] http://lists.freedesktop.org/archives/systemd-devel/2014-May/019631.html

Well abhay_salunke@dell.com bounces. Who at Dell is maintaining this
driver now? Maybe Mario can help finding the right person?

  Luis
