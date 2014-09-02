Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbaIBLWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:22:21 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:52801 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbaIBLWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:22:20 -0400
Date: Tue, 2 Sep 2014 07:22:12 -0400
From: An Tuan Ha <zero579911@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/12] Staging: rtl8821ae: hal_bt_coexist: fix commenting
 style
Message-ID: <20140902112212.GA2048@DARE>
References: <1409617776-30730-1-git-send-email-zero579911@gmail.com>
 <20140902091939.GB6600@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140902091939.GB6600@mwanda>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see, thanks, I will fix it, I was just worried about the subjects
being too long so I just stuck with the same subject; is there a
character limit on how long the subject line should be? Or as long as
it's reasonable, it'll be fine?

On Tue, Sep 02, 2014 at 12:19:40PM +0300, Dan Carpenter wrote:
> Hm...  Now you've broken it into *too* many separate patches.  Also the
> subjects are the same.  Also the subjects are too vague.  Which coding
> style issue is addressed?
> 
> It should be something like:
> patch 1: comments
> patch 2: add/remove spaces
> patch 3: fix quoted text
> patch 4: braces
> patch 5: add a blank line
> 
> regards,
> dan carpenter
> 
