Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbbAZNpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:45:07 -0500
Received: from mx-guillaumet.finsecur.com ([91.217.234.131]:58378 "EHLO
	guillaumet.finsecur.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbbAZNpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:45:04 -0500
Date: Mon, 26 Jan 2015 14:44:53 +0100
From: Sylvain Rochet <sylvain.rochet@finsecur.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Wenyou Yang <wenyou.yang@atmel.com>, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@free-electrons.com, peda@axentia.se
Message-ID: <20150126134453.GA27559@gradator.net>
References: <1422265005-22937-1-git-send-email-wenyou.yang@atmel.com>
 <1422265139-23011-1-git-send-email-wenyou.yang@atmel.com>
 <20150126103605.GA20837@gradator.net>
 <54C6426E.9090808@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54C6426E.9090808@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 172.16.8.13
X-SA-Exim-Mail-From: sylvain.rochet@finsecur.com
Subject: Re: [PATCH v2 02/12] pm: at91: Workaround DDRSDRC self-refresh bug
 with LPDDR1 memories.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on guillaumet.finsecur.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Nicolas,

On Mon, Jan 26, 2015 at 02:34:38PM +0100, Nicolas Ferre wrote:
> Le 26/01/2015 11:36, Sylvain Rochet a écrit :
> > 
> > I think we should explain we are dealing with an errata here, this is 
> > not obvious at first sight, the patch summary may find its place here :-)
> 
> True but the problem is that this errata is not public yet, it will be
> in a couple of weeks.
> 
> I have the feeling though that the commit message is pretty clear. We'll
> maybe add that it"s an actual errata.

Humm, this is not what I meant actually. I only proposed a code source 
comment explaining why this is done this way, the current patch summary 
looked like it will be perfect between /* */ ;-)

Sylvain
