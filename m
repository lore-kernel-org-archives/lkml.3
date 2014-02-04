Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaBDBFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 20:05:11 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:48699 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbaBDBFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 20:05:07 -0500
Date: Mon, 3 Feb 2014 17:05:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, mm-commits@vger.kernel.org,
        Joe Perches <joe@perches.com>, sebastian.capella@linaro.org
Subject: Re: + mm-utilc-add-kstrimdup.patch added to -mm tree
In-Reply-To: <CACVxJT-HUXmBepz-GW3T1+ANkSxt80=1-kNFyHLdk+RRjHaWQQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1402031704430.32346@chino.kir.corp.google.com>
References: <52ec195e.P8S/D298ZeaBLTvn%akpm@linux-foundation.org> <CACVxJT-HUXmBepz-GW3T1+ANkSxt80=1-kNFyHLdk+RRjHaWQQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Feb 2014, Alexey Dobriyan wrote:

> > kstrimdup() creates a whitespace-trimmed duplicate of the passed in
> > null-terminated string.  This is useful for strings coming from sysfs that
> > often include trailing whitespace due to user input.
> 
> I think kernel should be strict in what it accepts, otherwise
> case-insensivity and
> what not will be added some day.
> 
> Shell will trim whitespace for you.
> 

The last we heard, I think Sebastian is looking to redo this series and 
this patch is no longer needed.  Sebastian?
