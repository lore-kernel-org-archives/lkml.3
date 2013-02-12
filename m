Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab3BLVt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:49:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218Ab3BLVty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 16:49:54 -0500
Date: Tue, 12 Feb 2013 16:49:49 -0500
From: Dave Jones <davej@redhat.com>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: [PATCH 0/5] Add P state driver for Intel Core Processors
Message-ID: <20130212214949.GA1003@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, dirk.brandewie@gmail.com,
	linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
References: <1360170133-5066-1-git-send-email-dirk.brandewie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360170133-5066-1-git-send-email-dirk.brandewie@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 09:02:07AM -0800, dirk.brandewie@gmail.com wrote:
 > From: Dirk Brandewie <dirk.brandewie@gmail.com>
 > 
 > This driver implements a scaling driver with an internal governor for
 > Intel Core processors.  The driver follows the same model as the
 > Transmeta scaling driver (longrun.c) and implements the setpolicy()
 > instead of target().  Scaling drivers that implement setpolicy() are
 > assmuned to implement internal governors by the cpufreq core. All the
 > logic for selecting the current P state is contained within the driver
 > no external governor is used by the cpufreq core.
 > 
 > At the moment only Intel SandyBridge processors are supported. As
 > testing on SandyBridge+ processors is completed support will be added
 > to the driver.

Won't you also need to patch drivers/cpufreq/acpi-cpufreq.c to not load
on the processors that you want this driver to run on ?

	Dave

