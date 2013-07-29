Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab3G2JwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:52:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58227 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab3G2Jv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:51:58 -0400
Date: Mon, 29 Jul 2013 11:51:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Olivier Scherler <oscherler@ithink.ch>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] hid: Add new driver for non-compliant Xin-Mo devices.
In-Reply-To: <1374945602-11894-2-git-send-email-oscherler@ithink.ch>
Message-ID: <alpine.LNX.2.00.1307291151370.18809@pobox.suse.cz>
References: <1374945602-11894-1-git-send-email-oscherler@ithink.ch> <1374945602-11894-2-git-send-email-oscherler@ithink.ch>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jul 2013, oscherler@ithink.ch wrote:

> From: Olivier Scherler <oscherler@ithink.ch>
> 
> The driver currently only supports the Dual Arcade controller.
> It fixes the negative axis event values (the devices sends -2) to match the
> logical axis minimum of the HID report descriptor (the report announces -1).
> It is needed because hid-input discards out of bounds values.

Applied, thanks Olivier.

-- 
Jiri Kosina
SUSE Labs
