Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761133AbaCURYo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 13:24:44 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:54787 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbaCURYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 13:24:38 -0400
X-Auth-Info: ukhHopmnVBsSmgPWTKYMm7fk2DVUWzGSuWMOoQqLT6A=
Date: Fri, 21 Mar 2014 18:24:34 +0100
From: Gerhard Sittig <gsi@denx.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Alan Tull <atull@altera.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dinh Nguyen <dinguyen@altera.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 3/3] ARM: dts: socfpga: add gpio pieces
Message-ID: <20140321172434.GB3998@book.gsilab.sittig.org>
References: <1395345324-18299-1-git-send-email-bigeasy@linutronix.de>
 <1395345324-18299-4-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395345324-18299-4-git-send-email-bigeasy@linutronix.de>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 20:55 +0100, Sebastian Andrzej Siewior wrote:
> 
> The cycloneV has three gpio controllers, each one with 29 gpios. This patch
> adds the three controller with the gpio driver which is now sitting the
> gpio tree.

The third bank should have 27 pins, only the first two have 29.

The commit message probably should not discuss which git tree a
driver currently resides in.  This is just a temporary detail
which no longer applies to the mainline source base where your
patch will end up in.


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
