Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbaBGWqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 17:46:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59782 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaBGWqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 17:46:05 -0500
Date: Fri, 7 Feb 2014 14:47:15 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/73] init: delete the __cpuinit related stubs
Message-ID: <20140207224715.GB17133@kroah.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
 <1390339396-3479-2-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390339396-3479-2-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 04:22:04PM -0500, Paul Gortmaker wrote:
> The __cpuinit support was removed several releases ago.  People
> have had a chance to update their out of tree code, so now we
> remove the no-op stubs.
> 
> Also delete the mention of __cpuinitdata from the tag script.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
