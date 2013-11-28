Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935Ab3K1OBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:01:37 -0500
Received: from mail-wi0-f196.google.com ([209.85.212.196]:59277 "EHLO
	mail-wi0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3K1OBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:01:33 -0500
MIME-Version: 1.0
Date: Thu, 28 Nov 2013 19:31:32 +0530
Message-ID: <CAKK=TUJ=ebu3+hBQmm+5=uooCFo9y3oAS_JfSn_KOtfxCLBvQQ@mail.gmail.com>
Subject: Copying large files eats all of the RAM
From: venkata koppula <vmrkoppula@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am using cp command to copy a list of files each with size of around
1GB (copy within the same hard disk).

My laptop has 4GB of ram, before I issue the command around 1.5GB of memory
is used, when I issue the cp command around 3.7GB of memory is used.
And the cp command takes a lot of time to copy.

I am not able to launch other applications(take a lot of time) and
even compiz freezes frequently. my laptop has Ubuntu installed on it.

Is this the problem with only my system or it is a common problem with Linux?.

Is there any way to stop any copy command to use all of my memory.

Thanks
Venkat
