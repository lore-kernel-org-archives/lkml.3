Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab3LTIt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 03:49:58 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:45364 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab3LTIt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 03:49:57 -0500
Date: Fri, 20 Dec 2013 09:49:53 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: intel-mid: sfi_handle_*_dev() should check for
 pdata error code
Message-ID: <20131220084953.GB21133@gmail.com>
References: <1387244246-20714-1-git-send-email-david.a.cohen@linux.intel.com>
 <1387518179-4316-1-git-send-email-david.a.cohen@linux.intel.com>
 <1387518179-4316-2-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387518179-4316-2-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Cohen <david.a.cohen@linux.intel.com> wrote:

> Prevent sfi_handle_*_dev() to register device in case
> intel_mid_sfi_get_pdata() failed to execute.
> 
> Since 'NULL' is a valid return value, this patch makes
> sfi_handle_*_dev() functions to use IS_ERR() to validate returned pdata.

Is this bug triggering in practice? If not then please say so in the 
changelog. If yes then is this patch desired for v3.13 merging and 
also please fix the changelog to conform to the standard changelog 
style:

 - first describe the symptoms of the bug - how does a user notice?

 - then describe how the code behaves today and how that is causing
   the bug

 - and then only describe how it's fixed.

The first item is the most important one - while developers 
(naturally) tend to concentrate on the least important point, the last 
one.

Thanks,

	Ingo
