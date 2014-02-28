Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaB1NVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:21:13 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48219 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaB1NVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:21:11 -0500
Date: Fri, 28 Feb 2014 14:21:09 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        josh@joshtriplett.org
Subject: Re: [PATCH 14/46] kernel: Move prototype declaration to header
 file kernel/power/power.h
Message-ID: <20140228132109.GB16401@amd.pavel.ucw.cz>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
 <620346a9abff597545a6249d0d8c4adba8f1a1d9.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <620346a9abff597545a6249d0d8c4adba8f1a1d9.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-02-27 17:13:53, Rashika Kheria wrote:
> Move prototype declaration of function to header file
> kernel/power/power.h
> because it is used by more than one file.
> 
> This eliminates the following warning in kernel/power/snapshot.c:
> kernel/power/snapshot.c:1588:16: warning: no previous prototype for ‘swsusp_save’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
