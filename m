Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934316Ab3BTJWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:22:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934014Ab3BTJWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:22:14 -0500
Date: Wed, 20 Feb 2013 10:22:06 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Simon Wood <simon@mungewell.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] HID: LG: Add support for Logitech Momo Force (Red)
 Wheel
In-Reply-To: <1361330714-5217-1-git-send-email-simon@mungewell.org>
Message-ID: <alpine.LNX.2.00.1302201021200.17024@pobox.suse.cz>
References: <1361330714-5217-1-git-send-email-simon@mungewell.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2013, Simon Wood wrote:

> This patch provides a modified report descriptor to split accelerator
> and brake, and adds the 'NO_GET' flag to prevent it hanging on
> connection.

Applied, thanks Simon.

-- 
Jiri Kosina
SUSE Labs
