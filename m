Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaLRALZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 19:11:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaLRALY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 19:11:24 -0500
Date: Wed, 17 Dec 2014 16:11:23 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>, devel@driverdev.osuosl.org,
        HPDD-discuss@ml01.01.org, Greg Donald <gdonald@gmail.com>,
        James Simmons <uja.ornl@gmail.com>, linux-kernel@vger.kernel.org,
        Fabian Frederick <fabf@skynet.be>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        "John L. Hammond" <john.hammond@intel.com>
Subject: Re: [PATCH] staging: lustre: lustre: obdclass: lprocfs_status.c:
 Removed an unnecessary NULL check
Message-ID: <20141218001123.GA6548@kroah.com>
References: <1418853900-6887-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418853900-6887-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 11:05:00PM +0100, Rickard Strandqvist wrote:
> Removed an unnecessary NULL check. And clarified a switch statement.

That's two different things, please only do one thing in a patch, so
this would be 2 different patches.

please fix up and resend as a series of patches.

thanks,

greg k-h
