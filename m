Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbaHZHZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:25:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36116 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391AbaHZHZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:25:56 -0400
Date: Tue, 26 Aug 2014 09:25:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: =?ISO-8859-15?Q?=C9ric_Brunet?= <Eric.Brunet@lps.ens.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: input: force generic axis to be mapped to their
 user space axis
In-Reply-To: <1408986430-24451-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1408260925420.2992@pobox.suse.cz>
References: <1408986430-24451-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug 2014, Benjamin Tissoires wrote:

> Atmel 840B digitizer presents a stylus interface which reports twice
> the X coordinate and then twice the Y coordinate. In its current
> implementation, hid-input assign the first X to X, then the second to Y,
> then the first Y to Z, then the second one to RX.
> 
> This is wrong, and X should always be mapped to X, no matter what.
> A solution consists in forcing X, Y, Z, RX, RY, RZ to be mapped to their
> correct user space counter part.
> 
> Reported-by: Éric Brunet <Eric.Brunet@lps.ens.fr>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
