Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbaICJVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:21:31 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41809 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbaICJV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:21:29 -0400
Date: Wed, 3 Sep 2014 12:20:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, sparmaintainer@unisys.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: unisys: uislib: uisqueue.c: rewrite of
 do_locked_client_insert
Message-ID: <20140903092035.GJ6549@mwanda>
References: <1409681795-23262-1-git-send-email-sudipm.mukherjee@gmail.com>
 <20140903084038.GE6600@mwanda>
 <20140903085944.GA1184@sudip-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140903085944.GA1184@sudip-PC>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 02:29:44PM +0530, Sudip Mukherjee wrote:
> > This patch is much better and more interesting, but I still want some
> > more changes.
> > 
> I have already sent v3 of the patch just before your mail , based on 
> what greg k-h has suggested about the commnent. Please discard that.

Greg has a million emails in his inbox so you need to reply to the patch
itself if you want him to discard it.  If it's in a different thread he
can't keep track.

regards,
dan carpenter

