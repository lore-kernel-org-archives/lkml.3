Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab3D3GeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 02:34:16 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:63604 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab3D3GeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 02:34:15 -0400
MIME-Version: 1.0
Date: Tue, 30 Apr 2013 08:34:14 +0200
Message-ID: <CAC9WiBhpZFt+nk-hof9+hA12997ZMd+7pvwv9AnWB2FTY0r27Q@mail.gmail.com>
Subject: Why not are all serial devices named ttyS* ?
From: Francis Moreau <francis.moro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm just wondering why device nodes of some serial drivers (mostly
when arch != x86) are not always named "ttyS[:digit:]" ?

For example, I have a ARM based platform which has a serial device
node named "ttymxc0".

I don't see any advantages to do this but only require one to handle
special cases since most applications expect the ttyS* name.

Thanks
-- 
Francis
