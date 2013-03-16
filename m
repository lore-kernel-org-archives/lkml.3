Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3CPJFy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 05:05:54 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:30300 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab3CPJFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 05:05:52 -0400
Date: Sat, 16 Mar 2013 12:05:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 00/50] staging: omap-thermal: several code refactoring
Message-ID: <20130316090540.GQ9138@mwanda>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've reviewed this set.

I hate to make people redo whole patchset sets, and I hate
re-reviewing code.  Obviously, I don't really like the bunny hop
patches and I'm trying to discourage that going forward.  ;P  But
I wouldn't say it's a "Redo the whole thing" kind of problem.

Could just resend patch 33 and 47?  You should probably be able to
redo those without changing the rest.

regards,
dan carpenter

