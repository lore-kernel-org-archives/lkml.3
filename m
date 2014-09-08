Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbaIHQjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:39:13 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:39948 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbaIHQjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:39:12 -0400
Date: Mon, 8 Sep 2014 22:08:52 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
Cc: "Kershner, David A" <David.Kershner@unisys.com>,
        *S-Par-Maintainer <SParMaintainer@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: unisys: uislib: uislib.c: sparse warning of
 context imbalance
Message-ID: <20140908163852.GA5995@fool>
References: <1409908966-23148-1-git-send-email-sudipm.mukherjee@gmail.com>
 <C97001BC43954D438ACB059713BA5CDFC97127E0E1@USEA-EXCH7.na.uis.unisys.com>
 <20140908162714.GA5497@fool>
 <C97001BC43954D438ACB059713BA5CDFC97127E0E3@USEA-EXCH7.na.uis.unisys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C97001BC43954D438ACB059713BA5CDFC97127E0E3@USEA-EXCH7.na.uis.unisys.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 11:30:48AM -0500, Romer, Benjamin M wrote:
> On Mon, 2014-09-08 at 21:57 +0530, Sudip Mukherjee wrote:
> > Hi Ben,
> > thanks. the same file is having two more similar warnings. if you want i can
> > resend a patch fixing all the three warnings , or i can send two separate
> > patches. 
> > I personally will prefer two separate patches , as that will be
> > easier for you to test and review.
> > 
> > thanks
> > sudip
> 
> That would be perfect, thanks. :)
> 
> -- Ben

Hi Ben,
sorry to disturb you again. i got confused , which one is perfect one combined patch or 
separate patches?

thanks
sudip
