Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988Ab3BNO5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:57:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55584 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756720Ab3BNO5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:57:06 -0500
Date: Thu, 14 Feb 2013 14:57:03 +0000
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/2] regmap: debugfs: Ensure proper locking of
	`debugfs_off_cache' list
Message-ID: <20130214145703.GA24129@opensource.wolfsonmicro.com>
References: <1360845108-30428-1-git-send-email-dp@opensource.wolfsonmicro.com> <20130214145416.GQ13249@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130214145416.GQ13249@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 02:54:17PM +0000, Mark Brown wrote:
> On Thu, Feb 14, 2013 at 12:31:48PM +0000, Dimitris Papastamos wrote:
> 
> > There is a possible race between the read operations of the `registers'
> > file and the `range' file.  Close that down by taking the appropriate
> > locks when modifying/accessing the list.
> 
> This seems like an incremental fix on the previous change; the previous
> change introduced the ranges file with a race condition.  If splitting
> them up add the lock first and then add the ranges file that made it
> needed.
> 
> Please do also thread patch series together.

Aw yes, cool.
