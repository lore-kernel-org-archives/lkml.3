Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab3DOOxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 10:53:09 -0400
Received: from ra.se.axis.com ([195.60.68.13]:57594 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab3DOOxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 10:53:08 -0400
Date: Mon, 15 Apr 2013 16:51:34 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] cris: do not export "u8" and friends to userspace
Message-ID: <20130415145134.GF11974@axis.com>
References: <1364839386.21627.71.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364839386.21627.71.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 08:03:06PM +0200, Paul Bolle wrote:
> sv_addr_ag.h exports "u8" and friends to userspace. Use "__u8" and
> friends instead.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Looks good,

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
