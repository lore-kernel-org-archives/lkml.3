Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbaDVJ5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:57:14 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52756 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbaDVJ5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:57:08 -0400
Date: Tue, 22 Apr 2014 10:55:17 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Doug Anderson <dianders@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-samsung-soc@vger.kernel.org, olof@lixom.net, jslaby@suse.cz,
        paul.gortmaker@windriver.com, jg1.han@samsung.com, asierra@xes-inc.com,
        swarren@nvidia.com, heikki.krogerus@linux.intel.com,
        jschultz@xes-inc.com, kyle@infradead.org, mingo@elte.hu,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] serial_core: Commonalize crlf when working w/ a non
 open console port
Message-ID: <20140422105517.087a4459@alan.etchedpixels.co.uk>
In-Reply-To: <1398100003-4172-1-git-send-email-dianders@chromium.org>
References: <1397841448-12942-1-git-send-email-dianders@chromium.org>
	<1398100003-4172-1-git-send-email-dianders@chromium.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've moved the handling to uart_poll_put_char() to fix the above
> problems.  Now when I use kdb (and don't point console= to the same
> UART) I no longer get:
> 
> [0]kdb>
>        [0]kdb>
>               [0]kdb>
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

This seems sensible

Reviewed-by: Alan Cox <alan@linux.intel.com>
