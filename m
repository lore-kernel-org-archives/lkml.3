Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab3J0QGR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 12:06:17 -0400
Received: from mail.ukfsn.org ([5.9.116.23]:55088 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497Ab3J0QGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 12:06:16 -0400
Message-ID: <526D39F1.3080008@flitspace.org.uk>
Date: Sun, 27 Oct 2013 16:06:09 +0000
From: Rob Pearce <rob@flitspace.org.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131014 Thunderbird/17.0.9
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH] INTEL DRM DRIVERS : No LVDS hardware on Intel D410PT
 and D425KT
References: <526D16A2.60804@flitspace.org.uk> <20131027135152.GG18189@phenom.ffwll.local>
In-Reply-To: <20131027135152.GG18189@phenom.ffwll.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sun Oct 27 16:06:13 2013
X-DSPAM-Confidence: 1.0000
X-DSPAM-Probability: 0.0023
X-DSPAM-Signature: 526d39f546961225220421
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 27/10/13 13:51, Daniel Vetter wrote:
>> +		.matches = {
>> > +			DMI_MATCH(DMI_BOARD_VENDOR, "Intel"),
>> > +			DMI_MATCH(DMI_BOARD_NAME, "D425KT"),
> At least this one here has a KTW variant with lvds connector. I think we
> need a DMI_EXACT_MATCH. I haven't found out whether the D410PT board also
> has such a cousin, so please digg in a bit for me.
> 
Yes, you're right, sorry. I've had a dig and it looks like the D410PT
variants don't have LVDS (the differences in that range are legacy I/O,
PCIe and wireless). I'll re-submit with the 425 as an exact match.

Regards,
Rob


