Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab3BRSZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 13:25:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab3BRSZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 13:25:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 0/1] 3.0.66-stable review
Date: Mon, 18 Feb 2013 10:25:28 -0800
Message-Id: <20130218182321.620396886@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.66 release.
There is 1 patch in this series, which will be posted as a response to
this one.  If anyone has any issues with it being applied, please let me
know.

Responses should be made by Wed Feb 20 18:22:38 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.66-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.66-rc1

Alexandre SIMON <Alexandre.Simon@univ-lorraine.fr>
    printk: fix buffer overflow when calling log_prefix function from call_console_drivers


-------------

Diffstat:

 Makefile               |  4 ++--
 include/linux/syslog.h |  6 ++++++
 kernel/printk.c        | 13 ++++++++++++-
 3 files changed, 20 insertions(+), 3 deletions(-)


