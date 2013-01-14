Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab3ANMvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 07:51:04 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:40452 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556Ab3ANMvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 07:51:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux PM mailing list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: -next: no resume from suspend
Date: Mon, 14 Jan 2013 13:56:51 +0100
Message-ID: <16191961.j5ydKsJ3d3@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <50F3D9E8.6040802@suse.cz>
References: <50F3D9E8.6040802@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 14, 2013 11:11:52 AM Jiri Slaby wrote:
> Hi,
> 
> since friday's -next (the last known to be working is the last monday's)
> I cannot resume from suspend. The last thing I see with
> no_console_suspend is:
> i915: No ACPI video bus found
> 
> But I used to see the message always, so this is no difference. Any idea
> before I start bisecting?

Well, what's the next message you normally see with no_console_suspend?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
