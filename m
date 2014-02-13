Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaBMWOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 17:14:41 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:40322 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaBMWOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 17:14:39 -0500
Date: Thu, 13 Feb 2014 14:14:37 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christian Kujau <lists@nerdbynature.de>
cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-mm@kvack.org
Subject: Re: 3.14.0-rc2: WARNING: at mm/slub.c:1007
In-Reply-To: <alpine.DEB.2.19.4.1402131158590.6233@trent.utfs.org>
Message-ID: <alpine.DEB.2.02.1402131413070.13899@chino.kir.corp.google.com>
References: <alpine.DEB.2.19.4.1402131144390.6233@trent.utfs.org> <alpine.DEB.2.19.4.1402131158590.6233@trent.utfs.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Feb 2014, Christian Kujau wrote:

> > after upgrading from 3.13-rc8 to 3.14.0-rc2 on this PowerPC G4 machine, 
> > the WARNING below was printed.
> > 
> > Shortly after, a lockdep warning appeared (possibly related to my 
> > post to the XFS list yesterday[0]).
> 
> Sigh, only _after_ sending the email, I came across an earlier posting on 
> lkml: http://marc.info/?l=linux-mm&m=139145788623391
> 

There's a fix for that: http://marc.info/?l=linux-kernel&m=139145999324131
or alternatively wait for 3.14-rc3 which will already have it.
