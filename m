Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760943Ab3GaWrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:47:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55488 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757890Ab3GaWrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:47:04 -0400
Date: Thu, 1 Aug 2013 00:47:00 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next] hid/logitech-dj: Fix non-atomic kmalloc in
 logi_dj_ll_input_event()
In-Reply-To: <1375305478-26754-1-git-send-email-peter@hurleysoftware.com>
Message-ID: <alpine.LNX.2.00.1308010046510.18809@pobox.suse.cz>
References: <1375305478-26754-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jul 2013, Peter Hurley wrote:

> The ll_driver's .hidinput_input_event() method is called from
> atomic context [1]. Use GFP_ATOMIC for allocation of the
> synthesized hid report.
> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>

Applied, thanks Peter.

-- 
Jiri Kosina
SUSE Labs
