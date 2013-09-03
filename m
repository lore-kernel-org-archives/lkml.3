Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab3ICPCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 11:02:32 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55862 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab3ICPCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 11:02:31 -0400
Date: Tue, 3 Sep 2013 16:02:26 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Tom Gundersen <teg@jklm.no>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] input: allow SERIO=m even without EXPERT=y
Message-ID: <20130903150226.GA2392@srcf.ucam.org>
References: <1378147630-12471-1-git-send-email-teg@jklm.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378147630-12471-1-git-send-email-teg@jklm.no>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 08:47:10PM +0200, Tom Gundersen wrote:
> There is plenty of consumer hardware (e.g., mac books) that does not use
> AT keyboards or PS/2 mice. It therefore makes sense for distro kernels
> to build the related drivers as modules to avoid loading them on hardware
> that does not need them. As such, these options should no longer be protected
> by EXPERT.

There are systems (although, with luck, only *very* old ones) where the 
modules won't get autoloaded. You should probably mention that in the 
help text.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
