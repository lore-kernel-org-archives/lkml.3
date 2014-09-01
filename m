Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbaIAMd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:33:27 -0400
Received: from sym2.noone.org ([178.63.92.236]:60787 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbaIAMdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:33:25 -0400
Date: Mon, 1 Sep 2014 14:33:20 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: xillybus: Move out of staging
Message-ID: <20140901123320.GC4707@distanz.ch>
References: <1409471821-11809-1-git-send-email-eli.billauer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409471821-11809-1-git-send-email-eli.billauer@gmail.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-31 at 09:57:01 +0200, Eli Billauer <eli.billauer@gmail.com> wrote:
> This driver has been functional and stable throughout the year it has spent
> in the staging area. It has been patched for minor bugs, coding style issues
> and improvements during this period, so I suppose its time has come.
> 
> I shall continue being responsible for its maintenance.

In this case a entry in MAINTAINERS would make sense. This way you'll
make sure patches get submitted to you.
