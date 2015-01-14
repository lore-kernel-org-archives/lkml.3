Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbbANGfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 01:35:23 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:43650 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbbANGfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 01:35:22 -0500
Date: Tue, 13 Jan 2015 22:35:18 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Jia He <hejianet@gmail.com>
Cc: linux-kernel@vger.kernel.org, Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: lustre: libcfs: fix sparse warnings about
 static declaration
Message-ID: <20150114063518.GA18644@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Jia He <hejianet@gmail.com>, linux-kernel@vger.kernel.org,
	Oleg Drokin <oleg.drokin@intel.com>,
	Andreas Dilger <andreas.dilger@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1418740778-827-1-git-send-email-hejianet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418740778-827-1-git-send-email-hejianet@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jia He,

On Tue, Dec 16, 2014 at 10:39:38PM +0800, Jia He wrote:
> make sparse happy since these two fuchtion are only used in module.c.
> tested by successful compilation.
> 
spelling: s/fuchtion/function/

Not sure if "make sparse happy" is the best way to describe what you are
doing.  You are fixing sparse warnings.

[...]
> -void
> -kportal_memhog_free (struct libcfs_device_userstate *ldu)
> +static void kportal_memhog_free (struct libcfs_device_userstate *ldu)

You might as well fix the checkpatch warning created by this line too.

[...]

These functions aren't used outside of this file so making them static
looks correct.

-- 
- Jeremiah Mahler
