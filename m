Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab3JAPw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 11:52:27 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:54559 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab3JAPw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 11:52:26 -0400
Date: Tue, 1 Oct 2013 08:52:19 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [V2,03/35] watchdog: use dev_get_platdata()
Message-ID: <20131001155219.GA25022@roeck-us.net>
References: <008001ce8d13$c6805fc0$53811f40$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <008001ce8d13$c6805fc0$53811f40$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 06:58:51PM -0000, Jingoo Han wrote:
> Use the wrapper function for retrieving the platform data instead of
> accessing dev->platform_data directly.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> 
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
