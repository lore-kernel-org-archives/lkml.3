Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759701Ab3CGSm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 13:42:58 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:56619 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759509Ab3CGSmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 13:42:54 -0500
Date: Fri, 8 Mar 2013 00:12:41 +0530
From: Afzal Mohammed <afzal.mohd.ma@gmail.com>
To: Daniel Mack <zonque@gmail.com>
Cc: Fabio Estevam <festevam@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Question about fixed-clock
Message-ID: <20130307184240.GA3327@afzal-ThinkPad-R50e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130219033931.GA2479@afzal-ThinkPad-R50e>
 <51234B8E.2000504@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Tue, Feb 19, 2013 at 09:09:31AM +0530, Afzal Mohammed wrote:

> Hope invoking of_clk_init before clock generator driver helps

Mails coming from this id are in my personal capacity.

On Tue, Feb 19, 2013 at 10:53:18AM +0100, Daniel Mack wrote:
> On 19.02.2013 02:33, Fabio Estevam wrote:

> > Have you registered it with clk_register_fixed_rate() ?

> Hmm no, I didn't do anything else than adding it to the DT in the first
> place, hoping that a driver will pick it up and add the clock for me.
> But it turns out that of_clk_init() is not called at all on my platform.
> 
> I'm doing this now from omap_generic_init() and it works. If that's an
> appropriate place to call it, I can provide a patch.

Initially didn't realize that it was for an am335x based one.

I feel that for a platform having it's clock tree in DT, of_clk_init
would take care of it, but if clock tree data is not in DT, clock
tree would have to be extended in a non-DT way.

Regards
Afzal
