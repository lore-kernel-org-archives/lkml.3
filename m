Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbbAMF7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 00:59:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbbAMF7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 00:59:39 -0500
Date: Mon, 12 Jan 2015 19:40:59 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Fred Chou <fred.chou.nd@gmail.com>
Cc: forest@alittletooquiet.net, tvboxspy@gmail.com, guido@vanguardiasur.com.ar,
        joe@perches.com, gclement@baobob.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6655: remove unused function in mac.c
Message-ID: <20150113034059.GA16072@kroah.com>
References: <1418190616-25317-1-git-send-email-fred.chou.nd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418190616-25317-1-git-send-email-fred.chou.nd@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 01:50:16PM +0800, Fred Chou wrote:
> From: Fred Chou <fred.chou.nd@gmail.com>
> 
> Removed the unused function MACvGetShortRetryLimit, which also
> fixed the following sparse warning:
> drivers/staging/vt6655/mac.c:162:6: warning: 
> symbol 'MACvGetShortRetryLimit' was not declared. Should it be static?
> 
> Signed-off-by: Fred Chou <fred.chou.nd@gmail.com>
> ---
>  drivers/staging/vt6655/mac.c | 19 -------------------
>  1 file changed, 19 deletions(-)

Doesn't apply to my tree :(
