Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaHaSlI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 14:41:08 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:49224 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbaHaSlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 14:41:04 -0400
X-Originating-IP: 131.252.200.96
Date: Sun, 31 Aug 2014 11:40:50 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Huang Shijie <shijie8@gmail.com>, apw@canonical.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: denali: fix include guard and license block of
 denali.h
Message-ID: <20140831184050.GA4975@thin>
References: <1409310051-25726-1-git-send-email-yamada.m@jp.panasonic.com>
 <20140829183050.GA1532@thin>
 <1409407766.2664.0.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409407766.2664.0.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 07:09:26AM -0700, Joe Perches wrote:
> On Fri, 2014-08-29 at 11:30 -0700, Josh Triplett wrote:
> > (Side note: could we get checkpatch to complain about comment headers
> > containing the name of the file they appear in?  They're always either
> > redundant or wrong.)
> 
> Sure, if you can write a regex to determine an
> incorrect filename.

I was thinking more about matching the current filename, which seems
quite easy.

- Josh Triplett
