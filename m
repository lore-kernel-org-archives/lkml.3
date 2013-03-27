Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab3C0PKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:10:14 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36267 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab3C0PKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:10:12 -0400
Date: Wed, 27 Mar 2013 15:10:08 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Danny Baumann <dannybaumann@web.de>
Cc: David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] drm/i915: Allow specifying a minimum brightness
 level for sysfs control.
Message-ID: <20130327151007.GA13554@srcf.ucam.org>
References: <1364298525-4337-1-git-send-email-dannybaumann@web.de>
 <20130326170203.GA23549@srcf.ucam.org>
 <5151D686.9070701@web.de>
 <20130326172103.GA24566@srcf.ucam.org>
 <5152DE75.5010701@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5152DE75.5010701@web.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 12:56:37PM +0100, Danny Baumann wrote:

> OK, I see. And there is user space depending on that behaviour? And
> again - how is user space supposed to know about the behavioral
> differences? Is it something like 'if type is raw, don't expect
> anything'?

"Do not rely upon 0 being visible".

-- 
Matthew Garrett | mjg59@srcf.ucam.org
