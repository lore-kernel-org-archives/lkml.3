Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaJTLi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 07:38:26 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:39774 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaJTLiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 07:38:25 -0400
From: Chen Weixiang <weixiangchen@gmail.com>
X-Google-Original-From: Chen Weixiang <weixiang.chen@gmail.com>
Date: Mon, 20 Oct 2014 19:38:19 +0800
To: Konrad Zapalowicz <bergo.torino@gmail.com>
Cc: Chen Weixiang <weixiangchen@gmail.com>,
        Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greg Donald <gdonald@gmail.com>, Chen Gang <gang.chen.5i5j@gmail.com>,
        Artem Fetishev <wwctrsrx@gmail.com>,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] staging: ft1000: space required after that ','
Message-ID: <20141020113819.GA8743@chenwx>
Mail-Followup-To: Konrad Zapalowicz <bergo.torino@gmail.com>,
	Chen Weixiang <weixiangchen@gmail.com>,
	Marek Belisko <marek.belisko@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Greg Donald <gdonald@gmail.com>,
	Chen Gang <gang.chen.5i5j@gmail.com>,
	Artem Fetishev <wwctrsrx@gmail.com>,
	Andrey Utkin <andrey.krieger.utkin@gmail.com>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1413723590-19690-1-git-send-email-weixiang.chen@gmail.com>
 <1413723590-19690-4-git-send-email-weixiang.chen@gmail.com>
 <20141019132700.GA3632@t400>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141019132700.GA3632@t400>
User-Agent: Mutt/1.5.23 (b8a63730c848) (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 03:27:00PM +0200, Konrad Zapalowicz wrote:
> On 10/19, Chen Weixiang wrote:
> > -    u8 ConnectionMsg[] = {0x00,0x44,0x10,0x20,0x80,0x00,0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x93,0x64,
> > -                          0x00,0x00,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x0a,
> > -                          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
> > -                          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x12,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
> > -                          0x00,0x00,0x02,0x37,0x00,0x00,0x00,0x08,0x00,0x00,0x00,0x01,0x00,0x01,0x7f,0x00,
> > -                          0x00,0x01,0x00,0x00};
> > +    u8 ConnectionMsg[] = {0x00, 0x44, 0x10, 0x20, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x93, 0x64,
> > +                          0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0x0a,
> > +                          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +                          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x12, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +                          0x00, 0x00, 0x02, 0x37, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x7f, 0x00,
> > +                          0x00, 0x01, 0x00, 0x00};
> 
> Nice, however it still violates the 80 characters a line rule. Please
> redo this patch.
> Thanks,
> Konrad
>   

OK, I'll re-organize the array ConnectionMsg[], check the patches with
checkpatch and send the patches again. Thank you, Konrad.

-- 
Best regards,
Chen Weixiang (Alex)

