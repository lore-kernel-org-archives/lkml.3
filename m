Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbaGQBRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 21:17:31 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:36149 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbaGQBR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 21:17:29 -0400
Date: Wed, 16 Jul 2014 18:17:24 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Bean Huo <beanhuo@outlook.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Huang Shijie <b32955@freescale.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "christian.riesch@omicron.at" <christian.riesch@omicron.at>
Subject: Re: [PATCH v6] mtd:nor:timeout:fix do_write_buffer() timeout error
Message-ID: <20140717011724.GW7537@ld-irv-0074>
References: <BLU436-SMTP223B6F83933407357F0FF3BA6F70@phx.gbl>
 <20140716180423.GV7537@ld-irv-0074>
 <BLU185-W53748517956B27745D7033A6F40@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BLU185-W53748517956B27745D7033A6F40@phx.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 12:54:17AM +0000, Bean Huo wrote:
> > I have just fixed up your patch myself, to use max() and to improve some
> > of the language. Let me know if the below works for you.
> 
> hi,Brian
>  Thanks once again.I test and it works Ok.It can be accepted now? 		 	   		  

Yes. Pushed to l2-mtd.git.

Please be more diligent next time to follow CodingStyle and email
submission practices next time. Even if your company email gives
trouble, I'm sure you can find some way to send patches properly. For
instance, a quick search shows me that your outlook.com email supports
sending email via SMTP:

  http://windows.microsoft.com/en-us/windows/outlook/send-receive-from-app

That means you can, for instance, use git-send-email to send patches.

Brian
