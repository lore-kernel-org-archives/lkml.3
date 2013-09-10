Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab3IJPPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 11:15:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab3IJPPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 11:15:42 -0400
Date: Tue, 10 Sep 2013 08:15:41 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>, devel@driverdev.osuosl.org,
        Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: zram: minimize `slot_free_lock' usage (v2)
Message-ID: <20130910151541.GA7600@kroah.com>
References: <20130906151255.GE2238@swordfish.minsk.epam.com>
 <20130909123329.GZ19256@mwanda>
 <20130909124942.GA2221@swordfish.minsk.epam.com>
 <20130909132124.GY6329@mwanda>
 <522DD125.1030607@redhat.com>
 <522DF2DF.5060407@redhat.com>
 <20130910143416.GC2270@swordfish>
 <20130910145802.GD19256@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910145802.GD19256@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 05:58:02PM +0300, Dan Carpenter wrote:
> Btw, the devel@driverdev.osuosl.org list seems to be down again.  I
> still have not recieved the v3 patch.  Use the
> driverdev-devel@linuxdriverproject.org email list instead.

They are the same "list", just different DNS entries.  I'll go poke the
sysadmin to find out what's going on...

