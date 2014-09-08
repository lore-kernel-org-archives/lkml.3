Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbaIHRDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:03:09 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:37900 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbaIHRDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:03:07 -0400
Date: Mon, 8 Sep 2014 22:32:44 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
Cc: "Kershner, David A" <David.Kershner@unisys.com>,
        *S-Par-Maintainer <SParMaintainer@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: unisys: uislib: uislib.c: sparse warning of
 context imbalance
Message-ID: <20140908170244.GA9392@fool>
References: <1409908966-23148-1-git-send-email-sudipm.mukherjee@gmail.com>
 <C97001BC43954D438ACB059713BA5CDFC97127E0E1@USEA-EXCH7.na.uis.unisys.com>
 <20140908162714.GA5497@fool>
 <C97001BC43954D438ACB059713BA5CDFC97127E0E3@USEA-EXCH7.na.uis.unisys.com>
 <20140908163852.GA5995@fool>
 <C97001BC43954D438ACB059713BA5CDFC97127E0E4@USEA-EXCH7.na.uis.unisys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C97001BC43954D438ACB059713BA5CDFC97127E0E4@USEA-EXCH7.na.uis.unisys.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 11:48:44AM -0500, Romer, Benjamin M wrote:
> On Mon, 2014-09-08 at 22:08 +0530, Sudip Mukherjee wrote:
> > Hi Ben,
> > sorry to disturb you again. i got confused , which one is perfect one combined patch or 
> > separate patches?
> > 
> > thanks
> > sudip
> 
> Two patches, as you preferred.
> 
> -- Ben
> 
> 
ok. and if you get time can you please also have a look at :
[PATCH v4] staging: unisys: uislib: uisqueue.c: rewrite of do_locked_client_insert
Dan Carpenter has already reviwed it.

thanks
sudip

