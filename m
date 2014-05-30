Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbaE3WwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 18:52:17 -0400
Received: from master.debian.org ([82.195.75.110]:54314 "EHLO
	master.debian.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbaE3WwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 18:52:16 -0400
X-Greylist: delayed 1535 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 May 2014 18:52:15 EDT
Date: Sat, 31 May 2014 00:26:22 +0200
From: Jakub Wilk <jwilk@debian.org>
To: Manuel =?iso-8859-1?Q?Sch=F6lling?= <manuel.schoelling@gmx.de>
Cc: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, geert@linux-m68k.org,
        broonie@linaro.org, rdunlap@infradead.org, dh.herrmann@gmail.com,
        airlied@redhat.com, mtosatti@redhat.com, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console: Add persistent scrollback buffers for all VGA
 consoles
Message-ID: <20140530222622.GA1385@jwilk.net>
References: <1401456425-15931-1-git-send-email-manuel.schoelling@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401456425-15931-1-git-send-email-manuel.schoelling@gmx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Manuel Schölling <manuel.schoelling@gmx.de>, 2014-05-30, 15:27:
>Add a scrollback buffers for each VGA console. The benefit is that the 
>scrollback history is not flushed when switching between consoles but 
>is persistent.

Some people rely on this scrollback flushing as a security feature. Is 
there even another way to clear the scrollback, than to switch to 
another vt and then back again?

Debian ships this:
http://manpages.debian.org/cgi-bin/man.cgi?query=clear_console
https://sources.debian.net/src/bash/4.2%2Bdfsg-0.1/debian/clear_console.c

-- 
Jakub Wilk
