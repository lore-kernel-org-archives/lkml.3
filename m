Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaJCUeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 16:34:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43573 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaJCUeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 16:34:13 -0400
Date: Fri, 3 Oct 2014 13:34:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Giedrius Statkevicius <giedrius.statkevicius@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        fabio.falzoi84@gmail.com
Subject: Re: [PATCH 1/5] Combine ifs into one where possible to avoid
 unnecessary indentation level increase
Message-ID: <20141003203413.GA18227@kroah.com>
References: <1412368028-18935-1-git-send-email-giedrius.statkevicius@gmail.com>
 <1412368028-18935-2-git-send-email-giedrius.statkevicius@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1412368028-18935-2-git-send-email-giedrius.statkevicius@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 11:27:04PM +0300, Giedrius Statkevicius wrote:
> From: Giedrius Statkevičius <giedrius.statkevicius@gmail.com>
> 
> Join together chained if's where possible to lower the indentation level.
> 
> Signed-off-by: Giedrius Statkevičius <giedrius.statkevicius@gmail.com>

Your subject is "odd", in that it doesn't say what part of the kernel it
is for.  Look at the kernel git logs, it should give you an idea of how
to format things properly.

Also, you don't have to have such a long subject:, try to keep it short,
and then be verbose in the changelog body.

Can you fix up all of these 5 and resend?

thanks,

greg k-h
