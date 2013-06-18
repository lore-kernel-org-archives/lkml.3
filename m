Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab3FRJBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:01:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325Ab3FRJBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:01:39 -0400
Date: Tue, 18 Jun 2013 11:01:38 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Michael Rissi <michael.rissi@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Rissi <michael.rissi@dectris.com>
Subject: Re: [PATCH] HID: roccat: check cdev_add return values
In-Reply-To: <1371222997-4933-1-git-send-email-michael.rissi@dectris.com>
Message-ID: <alpine.LNX.2.00.1306181101150.6750@pobox.suse.cz>
References: <1371222997-4933-1-git-send-email-michael.rissi@dectris.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jun 2013, Michael Rissi wrote:

> Return value of cdev_add in hid_roccat.c init was not checked.
> 
> Signed-off-by: Michael Rissi <michael.rissi@dectris.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
