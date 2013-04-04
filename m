Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765203Ab3DDWXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 18:23:36 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:34738 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765160Ab3DDWXe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 18:23:34 -0400
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>
Subject: Re: 3.8.3 and 3.9git occasional watchdog oops
Date: Fri, 5 Apr 2013 00:23:30 +0200
User-Agent: KMail/1.13.7 (Linux/3.9.0-rc5-00184-gb6a9b7f; KDE/4.10.2; x86_64; ; )
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201303142154.20501.arekm@maven.pl>
In-Reply-To: <201303142154.20501.arekm@maven.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201304050023.31143.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 of March 2013, Arkadiusz Miśkiewicz wrote:
> Hi.
> 
> Just hit watchdog related oops in 3.8.3 kernel. Unfortunately photos only.
> 
> http://ixion.pld-linux.org/~arekm/watchdog-oops-3.8.3/IMG_8942.JPG
> http://ixion.pld-linux.org/~arekm/watchdog-oops-3.8.3/IMG_8941.JPG

3.9git from today isn't any better unfortunately:

http://ixion.pld-linux.org/~arekm/watchdog-oops-3.9git.jpg

> 
> oops started after I enabled systemd watchdog functionality. Cannot
> reproduce easily.
> 
> watchdog here (thinkpad t400) is:
>  iTCO_wdt: Found a ICH9M-E TCO device (Version=2, TCOBASE=0x1060)


-- 
Arkadiusz Miśkiewicz, arekm / maven.pl
