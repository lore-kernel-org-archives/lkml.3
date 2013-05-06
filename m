Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab3EFPY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:24:26 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:51007 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab3EFPYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:24:24 -0400
Message-ID: <1367853859.8434.11.camel@jlt4.sipsolutions.net>
Subject: Re: Bisected 3.9 regression for iwl4965 connection problem to
 1672c0e3
From: Johannes Berg <johannes@sipsolutions.net>
To: Jake Edge <jake@lwn.net>
Cc: linux-wireless@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Date: Mon, 06 May 2013 17:24:19 +0200
In-Reply-To: <20130506092143.58a7713f@chukar.edge2.net>
References: <20130505143803.7e46e4c6@chukar.edge2.net>
	 <1367853112.8434.6.camel@jlt4.sipsolutions.net>
	 <20130506092143.58a7713f@chukar.edge2.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-06 at 09:21 -0600, Jake Edge wrote:

> > Thanks for the report. Is the AP on a passive channel by any chance (5
> > GHz, or channels 12/13)?
> 
> No, from what I can see on my router, it is using channel 36 (5.180
> GHz) for the SSID in question

So yes, that is a passive channel for the 4965 device :-)

> but Stanislaw seems to have pinpointed the issue.

Yeah that was a workaround, but I'm not sure we'd really want to do
that. I'd rather see what really caused this issue. I have a feeling
it's the passive-no-RX workaround, or lack thereof maybe? I need to look
a bit closer.

johannes

