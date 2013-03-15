Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab3COWI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 18:08:56 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:37472 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab3COWIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 18:08:55 -0400
Date: Fri, 15 Mar 2013 15:08:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Dmitry Voytik <dvv.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: android: lowmemorykiller: well-marked debug
 print
In-Reply-To: <20130315200956.GA14440@kroah.com>
Message-ID: <alpine.DEB.2.02.1303151508070.32475@chino.kir.corp.google.com>
References: <1363377642-15414-1-git-send-email-dvv.kernel@gmail.com> <20130315200956.GA14440@kroah.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Mar 2013, Greg Kroah-Hartman wrote:

> > Add "lmk:" prefix to the debug print so it's easier to analyse LMK's
> > debug output:
> > dmesg | grep lmk
> 
> Ick, no, please use the proper interface for this (i.e. pr_fmt).
> 

And I'm sure that mysterious new "lmk:" messages appearing in the kernel 
log will be understood by about 0.00001% of people.
