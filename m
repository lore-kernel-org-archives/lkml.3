Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab3JZPvF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 11:51:05 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:56124 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753186Ab3JZPvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 11:51:02 -0400
Date: Sat, 26 Oct 2013 16:51:00 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Jasper Bryant-Greene <jbg@rf.net.nz>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: EFI boot problem in 3.11
Message-ID: <20131026155100.GC1982@console-pimps.org>
References: <32EA1272-FF5B-4FAA-B136-1447BF6F9876@rf.net.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <32EA1272-FF5B-4FAA-B136-1447BF6F9876@rf.net.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Oct, at 12:14:26PM, Jasper Bryant-Greene wrote:
> I have a box here which is set up for EFI boot with no boot loader.
> 
> The kernel is compiled with a built-in initrd and command line.
> 
> In 3.10 this was all working well. However, after updating to 3.11.5 a
> reboot leads to the EFI firmware boot screen appearing followed by the
> middle section of it going black (just leaving two vertical stripes of
> the EFI firmware boot screen on either side of the screen) and the
> system locking up (numlock etc do not work).
> 
> However, if I hit ‘delete’ quickly when powering on, and enter the
> firmware setup screen, I can then ‘exit without saving’ and the system
> will boot successfully — ‘save and exit’ does not work as that
> performs a full reboot while ‘exit without saving’ seems to continue
> the boot where it left off.
> 
> Due to the aforementioned graphics corruption, I am wondering whether
> it is somehow related to the frame buffer? As this is a production
> system I unfortunately do not have flexibility to try a number of
> kernel versions in-between to locate where the issue was introduced.

Nothing springs to mind and nothing jumps out of the log in
drivers/video or arch/x86/platform/efi.

The best way to figure out what's causing this issue really is to bisect
the kernel versions. What hardware are you running on?

-- 
Matt Fleming, Intel Open Source Technology Center
