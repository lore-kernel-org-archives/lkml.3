Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbaFCShE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:37:04 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38492 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbaFCSg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:36:59 -0400
Date: Tue, 3 Jun 2014 21:36:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chaitanya Hazarey <c@24.io>, andrea.merello@gmail.com,
        Greg KH <gregkh@linuxfoundation.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        burzalodowa@gmail.com
Subject: Re: [PATCH 2/4] Staging: rtl8192u: r8192U_wx.c Removed all C99
 comments
Message-ID: <20140603183644.GG15585@mwanda>
References: <1401725505-3459-1-git-send-email-c@24.io>
 <1401725505-3459-2-git-send-email-c@24.io>
 <CAMuHMdW1YnLVyZbmD0fadc6KX=EcH4CArC1379CDGb9ACm=GbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdW1YnLVyZbmD0fadc6KX=EcH4CArC1379CDGb9ACm=GbQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 10:12:23AM +0200, Geert Uytterhoeven wrote:
> What do other people think?

In staging we just automatically delete commented code.  It's in the git
log if you need it.  It always feels much better after the dead code is
gone.

regards,
dan carpenter

