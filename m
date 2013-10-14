Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab3JNODn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:03:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55556 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756410Ab3JNODl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:03:41 -0400
Date: Mon, 14 Oct 2013 16:03:35 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Elias Vanderstuyft <elias.vds@gmail.com>, Simon Wood <simon@mungewell.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?ISO-8859-15?Q?Michal_Mal=FD?= <madcatxster@prifuk.cz>
Subject: Re: [PATCHv2 3/3] HID:Kconfig: Correct MOMO description in wrong
 place (handled by LG4FF).
In-Reply-To: <CADbOyBQodqzSb04OCO6oduJSZvveZXxQjSdp+CdyKKk5Bs=O7w@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1310141602540.12405@pobox.suse.cz>
References: <alpine.LNX.2.00.1310101002120.13289@pobox.suse.cz> <1381414814-2107-1-git-send-email-simon@mungewell.org> <1381414814-2107-3-git-send-email-simon@mungewell.org> <CADbOyBQodqzSb04OCO6oduJSZvveZXxQjSdp+CdyKKk5Bs=O7w@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Oct 2013, Elias Vanderstuyft wrote:

> I don't see any report-descriptor being fixed up, this results in having
> only two axes: steering and combined accel-brake axis.
> So, same procedure as the Formula Vibration wheel, I'll send you the report
> descriptor and some hidraw data when using the accel and brake pedals, in
> my next mail.

So should I wait for v3, where the rdesc fixup for splitting the axes will 
be done, or are you planning to submit it to me as a followup patch?

-- 
Jiri Kosina
SUSE Labs
