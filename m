Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaAGO7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:59:04 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:38734 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaAGO6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:58:50 -0500
MIME-Version: 1.0
In-Reply-To: <ab8110369e392324f0d90368d638bc38@meetr.de>
References: <1389088723-30959-1-git-send-email-artagnon@gmail.com>
 <20140107135409.GA21190@thinkpad-t410> <CALkWK0nL3JOvznns2vApzV9+d1JDLgLX=x=6epw-JMEzANMWDA@mail.gmail.com>
 <ab8110369e392324f0d90368d638bc38@meetr.de>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 7 Jan 2014 20:28:09 +0530
Message-ID: <CALkWK0muwWStc5Ypz2DNbNEsXBzO_yKTA+Qbc3QZ3EL1WRi6gQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] Get EDID late for VGA switcheroo
To: Andreas Heider <andreas@meetr.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

andreas@meetr.de wrote:
> You can switch the line used to detect the display separately from the line
> which is used to display the picture, so you can just switch DDC to the
> intel card when you know it will try to detect the display, without having
> to introduce flickering. There were a few different versions of patches that
> did this, I think this one is the latest:
> http://lists.freedesktop.org/archives/dri-devel/2012-September/027528.html

Any idea why this series didn't get merged?
