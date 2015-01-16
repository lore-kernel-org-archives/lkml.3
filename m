Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbbAPGVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 01:21:46 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:58414 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbbAPGVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 01:21:45 -0500
Date: Thu, 15 Jan 2015 22:21:41 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Jia He <hejianet@gmail.com>
Cc: linux-kernel@vger.kernel.org, Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2] staging: lustre: libcfs: fix space between function
 and open parenthesis
Message-ID: <20150116062141.GA4658@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Jia He <hejianet@gmail.com>, linux-kernel@vger.kernel.org,
	Oleg Drokin <oleg.drokin@intel.com>,
	Andreas Dilger <andreas.dilger@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20150114063518.GA18644@hudson.localdomain>
 <1421372747-2954-1-git-send-email-hejianet@gmail.com>
 <1421372747-2954-2-git-send-email-hejianet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421372747-2954-2-git-send-email-hejianet@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jia He,

On Fri, Jan 16, 2015 at 09:45:47AM +0800, Jia He wrote:
> This fixes the space warning checked by check_patch.pl
                                              ^^^
                                          checkpatch.pl
> 
[...]
> -static void kportal_memhog_free (struct libcfs_device_userstate *ldu)
> +static void kportal_memhog_free(struct libcfs_device_userstate *ldu)
>  {
[...]

I would have included this change in with the previous patch since it is
that patch that has the checkpatch warning.

-- 
- Jeremiah Mahler
