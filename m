Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab3DYIak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 04:30:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32964 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab3DYIai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 04:30:38 -0400
Date: Thu, 25 Apr 2013 10:30:35 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] uio/aec: specify correct license in MODULE_LICENSE
Message-ID: <20130425083035.GQ15233@pengutronix.de>
References: <1366875462-7864-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <CAFLxGvxjdYDP4ts9-PNwPWJRi+eCu3vtM+Stz2TkvTXVU7FTXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFLxGvxjdYDP4ts9-PNwPWJRi+eCu3vtM+Stz2TkvTXVU7FTXA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 10:25:11AM +0200, richard -rw- weinberger wrote:
> On Thu, Apr 25, 2013 at 9:37 AM, Uwe Kleine-König
> <u.kleine-koenig@pengutronix.de> wrote:
> > The file header declares the code to be covered by GPL v2 only, so use
> > explicit v2 for MODULE_LICENSE, too.
> 
> Doesn't this apply to almost any driver?
> I don't understand why you explicitly "fix" this one.
I fix this driver because I stumbled about it. And yes, I think there
are several more affected, I just didn't come around yet to write a
script.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
