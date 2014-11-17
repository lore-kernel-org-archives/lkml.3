Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaKQJZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 04:25:01 -0500
Received: from sym2.noone.org ([178.63.92.236]:55382 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbaKQJZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 04:25:00 -0500
Date: Mon, 17 Nov 2014 10:24:56 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Dmitry Torokhov <dtor@chromium.org>
Cc: Ley Foon Tan <lftan@altera.com>, nios2-dev@lists.rocketboards.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nios2: fix error handling of irq_of_parse_and_map
Message-ID: <20141117092456.GA3247@distanz.ch>
References: <20141114220419.GA32497@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114220419.GA32497@dtor-ws>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-14 at 23:04:19 +0100, Dmitry Torokhov <dtor@chromium.org> wrote:
> Return value of irq_of_parse_and_map() is unsigned int, with 0
> indicating failure, so testing for negative result never works.
> 
> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>

Reviewed-by: Tobias Klauser <tklauser@distanz.ch>

Thanks for catching this.
