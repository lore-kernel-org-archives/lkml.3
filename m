Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbbAFVV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:21:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49712 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbbAFVV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:21:58 -0500
Date: Tue, 6 Jan 2015 22:21:56 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ross Skaliotis <rskaliotis@gmail.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: Fix battery support for the 2009 ANSI Apple wireless
 keyboard.
In-Reply-To: <1419120095-11889-1-git-send-email-rskaliotis@gmail.com>
Message-ID: <alpine.LNX.2.00.1501062221400.25732@pobox.suse.cz>
References: <1419120095-11889-1-git-send-email-rskaliotis@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Dec 2014, Ross Skaliotis wrote:

> Enabled quirks necessary for correct battery capacity reporting. Cleaned up
> surrounding style.
> 
> Signed-off-by: Ross Skaliotis <rskaliotis@gmail.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
