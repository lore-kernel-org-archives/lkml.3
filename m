Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab3EUJrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 05:47:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196Ab3EUJrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 05:47:14 -0400
Date: Tue, 21 May 2013 11:47:11 +0200
From: Karel Zak <kzak@redhat.com>
To: Linda Walsh <lkml@tlinx.org>
Cc: util-linux@vger.kernel.org, Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: mount --no-canonical seems broken.
Message-ID: <20130521094711.GD11688@x2.net.home>
References: <5175BA15.9060803@tlinx.org>
 <20130423123648.GB24501@x2.net.home>
 <517729C7.2030806@tlinx.org>
 <20130520074001.GE16493@x2.net.home>
 <519AB20D.7030503@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519AB20D.7030503@tlinx.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 04:30:21PM -0700, Linda Walsh wrote:
>  widely known as "df" or "mount".
> 
> I might point out that by default,
> > findmnt /
> 
> TARGET SOURCE    FSTYPE OPTIONS
> /      /dev/root xfs    rw,nodiratime,relatime,attr2,inode64,noquota
> > > l /dev/root
> ls: cannot access /dev/root: No such file or directory

 util-linux 2.23 ? 
 
 libmount since this version is able to use the root= kernel command
 line option to convert /dev/root from the /proc/self/mountinfo file
 to a real device name.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
