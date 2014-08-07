Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbaHGJgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:36:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54133 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbaHGJgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:36:17 -0400
Date: Thu, 7 Aug 2014 11:36:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Marcel Holtmann <marcel@holtmann.org>, Pali Roh?r <pali.rohar@gmail.com>,
        Miguel Oliveira <cmroliv@gmail.com>, gulsah.1004@gmail.com,
        peter.p.waskiewicz.jr@intel.com, kristina.martsenko@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: nokia_h4: merge firmware together so that we
 can reduce ammount of exports
Message-ID: <20140807093609.GA28649@Nokia-N900>
References: <1401445633-5290-1-git-send-email-cmroliv@gmail.com>
 <20140530123023.GA10549@amd.pavel.ucw.cz>
 <20140530155959.GA10682@kroah.com>
 <201405301815.10811@pali>
 <20140530163604.GA11943@kroah.com>
 <DB71A450-EF1D-479F-9111-A36FF8EA89B2@holtmann.org>
 <20140806213055.GA26046@amd.pavel.ucw.cz>
 <20140807002532.GB23406@kroah.com>
 <20140807090733.GC24700@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807090733.GC24700@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-08-07 11:07:34, Pavel Machek wrote:
> 
> Merge firmware files to nokia_core, so that we can reduce ammount of
> exported functions. Also replace hand-coded check for invalid
> bluetooth address with bacmp.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

Actually, it might be better if you forgot about this
patch. The code is more tangled up than I expected.


					Pavel
