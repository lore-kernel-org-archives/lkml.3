Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab3CPHOJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 03:14:09 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:61742 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab3CPHOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 03:14:07 -0400
Date: Sat, 16 Mar 2013 11:14:01 +0400
From: Dmitry Voytik <dvv.kernel@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: android: lowmemorykiller: well-marked debug
 print
Message-ID: <20130316071401.GA17530@voyt-hp>
References: <1363377642-15414-1-git-send-email-dvv.kernel@gmail.com>
 <20130315200956.GA14440@kroah.com>
 <alpine.DEB.2.02.1303151508070.32475@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1303151508070.32475@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 03:08:52PM -0700, David Rientjes wrote:
> > Ick, no, please use the proper interface for this (i.e. pr_fmt).
> > 
> 
> And I'm sure that mysterious new "lmk:" messages appearing in the kernel 
> log will be understood by about 0.00001% of people.

David, Greg,

Thank you for fair comments. In the following e-mail I'll send the fixed
patch according to your comments.
