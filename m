Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760225AbaCUIRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 04:17:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756038AbaCUIRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 04:17:21 -0400
Date: Fri, 21 Mar 2014 09:17:18 +0100
From: Karel Zak <kzak@redhat.com>
To: Janani Venkataraman <jananive@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, util-linux@vger.kernel.org
Subject: Re: [PATCH 00/33] [RFC] Non disruptive application core dump
 infrastructure
Message-ID: <20140321080855.GE26374@x2.net.home>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 03:09:03PM +0530, Janani Venkataraman wrote:
> Gencore Daemon
> 
> The programs can request a dump using gencore() API, provided through
> libgencore. This is implemented through a daemon which listens on a UNIX File
> socket. The daemon is started immediately post installation.

 The gencore command looks like a good idea, but why we need the
 client-server infrastructure? At least at first glance it seems
 like overkill.

> We would like to push this to one of the following packages:
> a) util-linux
> b) coreutils
> c) procps-ng

  d) somewhere near to gdb :-)

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
