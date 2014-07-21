Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523AbaGUOy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:54:29 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40354 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbaGUOy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:54:28 -0400
Date: Mon, 21 Jul 2014 15:54:21 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Allow case labels with ranges
Message-ID: <20140721145421.GA28529@lee--X1>
References: <20140721113948.GX30888@lee--X1>
 <1405948406.21586.10.camel@joe-AO725>
 <20140721132116.GZ30888@lee--X1>
 <1405952929.27900.7.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405952929.27900.7.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2014, Joe Perches wrote:

> On Mon, 2014-07-21 at 14:21 +0100, Lee Jones wrote:
> > On Mon, 21 Jul 2014, Joe Perches wrote:
> > > The MISSING_BREAK / fallthrough test does not support
> > > gcc's extension for case labels with ranges.
> []
> > Yep, that's much worse [1] - I wish I never mentioned it. ;)
> 
> I'm glad you did actually.
> 
> The code itself:
> 
> bool foo(int bar)
> {
> 	case (bar) {
> 	case 1:
> 	case 2:
> 	case 4:
> 		return true;
> 	default:
> 		return false;
> }
> 
> should not emit any error.

That's why I submitted the report.

> I'll fix it soon.

Brilliant, thanks Joe!

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
