Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab3HFKJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 06:09:07 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:41858 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab3HFKJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 06:09:05 -0400
Date: Tue, 6 Aug 2013 12:09:00 +0200
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: justin mattock <justin.mattock@hotmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Greg KH <gregkh@linuxfoundation.org>,
        Justin Mattock <justinmattock@gmail.com>,
        "mujeeb.adil@gmail.com" <mujeeb.adil@gmail.com>,
        "harsh1kumar@gmail.com" <harsh1kumar@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linux List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Staging: winbond: Fixed some coding style issues
Message-Id: <20130806120900.9af9bfd4a9822515c12f625d@gmail.com>
In-Reply-To: <BLU404-EAS29314E6ABCC44081AB2429955C0@phx.gbl>
References: <BLU404-EAS29314E6ABCC44081AB2429955C0@phx.gbl>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I send it. If you haven't received it, maybe you have misplaced it, you can look at it in the following archive: http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg480978.html

On Mon, 5 Aug 2013 18:22:48 +0000
justin mattock <justin.mattock@hotmail.com> wrote:

> where patch #2?
> 
> 
> 
> Justin P. Mattock
> 
> 
> 
> From: Iker Pedrosa
> Sent: ‎Monday‎, ‎August‎ ‎5‎, ‎2013 ‎2‎:‎58‎ ‎AM
> To: pavel@ucw.cz
> Cc: gregkh@linuxfoundation.org, justinmattock@gmail.com, ikerpedrosam@gmail.com, mujeeb.adil@gmail.com, harsh1kumar@gmail.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
> 
> 
> Fixes some coding style issues from drivers/staging/winbond
> 
> Iker Pedrosa (6):
>   Staging: winbond: wb35reg: changed sleep function from msleep to
>     usleep
>   Staging: winbond: wb35reg: white space deleted
>   Staging: winbond: wb35reg: avoided use of extern function
>   Staging: winbond: mds: fixed some lines over 80 characters
>   Staging: winbond: mds_f: fixed lines over 80 characters
>   Staging: winbond: mds_f: deleted extern function
> 
>  drivers/staging/winbond/mds.c             | 56 ++++++++++++++++++-------------
>  drivers/staging/winbond/mds_f.h           | 13 ++++---
>  drivers/staging/winbond/phy_calibration.h |  1 +
>  drivers/staging/winbond/wb35reg.c         | 13 ++++---
>  4 files changed, 48 insertions(+), 35 deletions(-)
> 
> -- 
> 1.8.1.2

-- 
Iker Pedrosa <ikerpedrosam@gmail.com>
