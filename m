Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422954Ab3FUOTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:19:11 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:44713 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422708Ab3FUOTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:19:09 -0400
Date: Fri, 21 Jun 2013 16:19:06 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Dirk Schmidt <derschmied@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Amd Phenom 2 X6 Cool&Quiet Issue.
Message-ID: <20130621141906.GA526@x4>
References: <51C4600E.6030005@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C4600E.6030005@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.06.21 at 16:15 +0200, Dirk Schmidt wrote:
> Amd Phenom 2 X6 Cool&Quiet Issue.
> 
> Problem:
> 
> dmesg | grep power
> [   10.622426] powernow-k8: This CPU is not supported anymore, using 
> acpi-cpufreq instead.
> 
> modprobe acpi_cpufreq
> ERROR: could not insert 'acpi_cpufreq': No such device

Please post your kernel .config.

-- 
Markus
