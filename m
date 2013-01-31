Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab3AaPPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 10:15:11 -0500
Received: from host171.canaca.com ([67.55.55.225]:33093 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab3AaPPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 10:15:09 -0500
Message-ID: <bc26a4ded50b76e213708a64b857ce1f.squirrel@mungewell.org>
In-Reply-To: <1359644830-3274-1-git-send-email-simon@mungewell.org>
References: <alpine.LNX.2.00.1301291057170.23853@pobox.suse.cz>
    <1359644830-3274-1-git-send-email-simon@mungewell.org>
Date: Thu, 31 Jan 2013 10:15:07 -0500
Subject: Re: [PATCH 1/5] USB: HID: SRW-S1 Gaming Wheel Driver
From: simon@mungewell.org
To: "Simon Wood" <simon@mungewell.org>
Cc: linux-input@vger.kernel.org, "Jiri Kosina" <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, simon@mungewell.org,
        rosegardener@freeode.co.uk
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add support the SRW-S1 by patching HID descriptor to read axis
> as Generic Desktop X, Y and Z (rather than Usage page being
> 'Simulation').

Slight glitch in making this patch set, there is no [5/5] - just the 4
parts as sent.... sorry if this causes confusion.

Simon.

