Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbaLRXGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 18:06:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57965 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaLRXGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 18:06:05 -0500
Date: Thu, 18 Dec 2014 15:06:04 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2] stable_kernel_rules: reorganize and update submission
 options
Message-ID: <20141218230604.GB12348@kroah.com>
References: <1418886676-27036-1-git-send-email-computersforpeace@gmail.com>
 <20141218225553.GC9759@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141218225553.GC9759@ld-irv-0074>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 02:55:53PM -0800, Brian Norris wrote:
> The current organization of Documentation/stable_kernel_rules.txt
> doesn't clearly differentiate the mutually exclusive options for
> submission to the -stable review process. As I understand it, patches
> are not actually required to be mailed directly to
> stable@vger.kernel.org, but the instructions do not make this clear.
> 
> Also, there are some established processes that are not listed --
> specifically, what I call Option 2 below.
> 
> This patch updates and reorganizes a bit, to make things clearer.
> 
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> ---
> v2: add some more items to Option 2 to suit Greg's liking
> 
>  Documentation/stable_kernel_rules.txt | 44 +++++++++++++++++++++++++++--------
>  1 file changed, 34 insertions(+), 10 deletions(-)

Looks good, I'll queue this up after 3.19-rc1 is out.

thanks,

greg k-h
