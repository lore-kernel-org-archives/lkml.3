Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbaKSVLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:11:55 -0500
Received: from 1wt.eu ([62.212.114.60]:55774 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756651AbaKSVLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:11:40 -0500
Date: Wed, 19 Nov 2014 22:11:35 +0100
From: Willy Tarreau <w@1wt.eu>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/9] staging: panel: Refactor LCD init code
Message-ID: <20141119211135.GF30756@1wt.eu>
References: <1416429531-11088-1-git-send-email-marius.gorski@gmail.com> <1416429531-11088-8-git-send-email-marius.gorski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416429531-11088-8-git-send-email-marius.gorski@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 09:38:49PM +0100, Mariusz Gorski wrote:
> Rework lcd_init method to make it a little bit more clear about
> the precedence of the params, move LCD geometry and pins layout
> to the LCD struct and thus make the LCD-related module params
> effectively read-only.
> 
> Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>

Acked-by: Willy Tarreau <w@1wt.eu>
