Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbaCJVoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 17:44:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41649 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138AbaCJVn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 17:43:59 -0400
Date: Mon, 10 Mar 2014 14:43:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, linux-arm-msm@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 2/6] rtc: pm8xxx: use regmap API for register
 accesses
Message-Id: <20140310144358.127497cb2ba133d964bd43a2@linux-foundation.org>
In-Reply-To: <20140310213524.GL18529@joshc.qualcomm.com>
References: <1394477089-3996-1-git-send-email-joshc@codeaurora.org>
	<1394477089-3996-3-git-send-email-joshc@codeaurora.org>
	<20140310134741.e5b97d12d47e1b990501f8bc@linux-foundation.org>
	<20140310213524.GL18529@joshc.qualcomm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014 16:35:24 -0500 Josh Cartwright <joshc@codeaurora.org> wrote:

> On Mon, Mar 10, 2014 at 01:47:41PM -0700, Andrew Morton wrote:
> > On Mon, 10 Mar 2014 13:44:45 -0500 Josh Cartwright <joshc@codeaurora.org> wrote:
> > > Now that the parent mfd driver has been made to work again, and has been
> > > reworked to create a regmap instance intended for it's children to use,
> > > rework the pm8xxx driver to use the regmap API for it's register
> > > accesses.
> > 
> > Do we need a 
> > 
> > 	depends on REGMAP
> > 
> > in Kconfig?
> 
> Good question.  This driver already gets the REGMAP dependency through
> it's parent (MFD_PM8XXX), which does 'select REGMAP'.

OK, thanks, that sounds sufficient.

