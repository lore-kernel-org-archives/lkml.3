Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaEYXam (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 19:30:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaEYXal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 19:30:41 -0400
Date: Sun, 25 May 2014 16:30:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Masaru Nomura <massa.nomura@gmail.com>
Cc: andreas.dilger@intel.com, Oleg Drokin <green@linuxhacker.ru>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging: lustre: lnet: klnds: Fix coding style in
 socklnd.c
Message-ID: <20140525233039.GA28206@kroah.com>
References: <1401056652-596-1-git-send-email-massa.nomura@gmail.com>
 <20140525223719.GA24682@kroah.com>
 <CAAvxhqCX=PmSerzQZKdpUQCiehhEeGDs1RN1woYL_oJ++EkzQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAvxhqCX=PmSerzQZKdpUQCiehhEeGDs1RN1woYL_oJ++EkzQg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2014 at 11:50:03PM +0100, Masaru Nomura wrote:
> 
> 
> 
> 2014-05-25 23:37 GMT+01:00 Greg KH <gregkh@linuxfoundation.org>:
> 
>     On Sun, May 25, 2014 at 11:24:12PM +0100, Masaru Nomura wrote:
>     > Remove prohibited space between function name and
>     > open parenthesis to meet kernel coding style.
>     > Also fix indenting due to changes to keep readability.
>     >
>     > -since v2:
>     > None. This is the resend of v2 as v2 failed to apply
> 
>     This should be below the --- line.
> 
> 
> 
> I'm sorry for that. Will fix it.
>  
> 
>     And it still doesn't apply :(
> 
>     What branch did you make it against?
> 
> 
> 
> I'm using[1] which is your staging.git (is it correct?) and downloaded it
> today.  So, there should not be a patch failure... :(

What _branch_ of that git tree did you make it against?

And please don't send html email, the mailing lists reject it.

thanks,

greg k-h
