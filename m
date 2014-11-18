Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795AbaKRVXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:23:32 -0500
Received: from 1wt.eu ([62.212.114.60]:53266 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110AbaKRVXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:23:31 -0500
Date: Tue, 18 Nov 2014 22:23:26 +0100
From: Willy Tarreau <w@1wt.eu>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] staging: panel: Refactor LCD init code
Message-ID: <20141118212326.GJ26514@1wt.eu>
References: <1416344174-9155-1-git-send-email-marius.gorski@gmail.com> <1416344174-9155-8-git-send-email-marius.gorski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416344174-9155-8-git-send-email-marius.gorski@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 09:56:12PM +0100, Mariusz Gorski wrote:
> Rework lcd_init method to make it a little bit more clear about
> the precedence of the params, move LCD geometry and pins layout
> to the LCD struct and thus make the LCD-related module params
> effectively read-only.
> 
> Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>

Acked-by: Willy Tarreau <w@1wt.eu>

I like this refactoring. However I don't know if you got your LCD module
to work or not, but for such important changes you should definitely test
the code, since it's very easy to introduce minor bugs or even to fix a
bug that used to make the whole driver work...

Willy

