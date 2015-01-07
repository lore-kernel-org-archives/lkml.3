Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbbAGAkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 19:40:35 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:51356 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbbAGAkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 19:40:33 -0500
Date: Tue, 6 Jan 2015 16:40:28 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jeremiah Mahler <jmmahler@gmail.com>, "jeffrey.lin" <yajohn@gmail.com>,
        rydberg@euromail.se, shc_work@mail.ru, charliemooney@chromium.org,
        bleung@chromium.org, lee.jones@linaro.org, jeffrey.lin@rad-ic.com,
        roger.yang@rad-ic.com, KP.li@rad-ic.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] driver: input :touchscreen : add Raydium I2C touch driver
Message-ID: <20150107004028.GB12798@dtor-ws>
References: <1420536350-5916-1-git-send-email-jeffrey.lin@rad-ic.com>
 <20150106194354.GA12576@hudson.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106194354.GA12576@hudson.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 11:43:54AM -0800, Jeremiah Mahler wrote:
> On Tue, Jan 06, 2015 at 05:25:50PM +0800, jeffrey.lin wrote:
> > From: "jeffrey.lin" <jeffrey.lin@rad-ic.com>
> > 
> > This patch is porting Raydium I2C touch driver. Developer can enable
> >  raydium touch driver by modifying define "CONFIG_TOUCHSCREEN_RM_TS".
> > 
> > Signed-off-by: jeffrey.lin@rad-ic.com
> 
> You need your full legal name in your Signed-off-by:

Also, there was feedback provided earlier and I still see it not being
addresses (the presence of custom char dev interface for example). It
would also be helpful if refreshed mentioned what was change from the
previos version.

Thanks.

-- 
Dmitry
