Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbaCGVZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:25:58 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55962 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaCGVZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:25:57 -0500
Date: Fri, 7 Mar 2014 21:25:45 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Jean Delvare <jdelvare@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] mfd: Fix cs5535 dependencies
Message-ID: <20140307212545.6c1dab79@alan.etchedpixels.co.uk>
In-Reply-To: <20140307220051.0b004abf@endymion.delvare>
References: <20140307220051.0b004abf@endymion.delvare>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2014 22:00:51 +0100
Jean Delvare <jdelvare@suse.de> wrote:

> As far as I know, the CS5535 and CS5536 chipsets are companions of the
> Geode series of processors, which are 32-bit only. So the CS5535
> drivers are not needed on x86-64, except for build testing purpose.
> 
> This aligns the dependencies to what FB_GEODE already uses.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>

This looks correct to me. Also true for the ATA driver and a few others
plus for the CS5510 and 5520.

Alan
