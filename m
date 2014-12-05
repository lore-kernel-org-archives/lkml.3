Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbaLEXOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:14:37 -0500
Received: from 1wt.eu ([62.212.114.60]:37098 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbaLEXOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 18:14:36 -0500
Date: Sat, 6 Dec 2014 00:14:29 +0100
From: Willy Tarreau <w@1wt.eu>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: panel: Remove magic numbers in LCD commands
Message-ID: <20141205231429.GA3051@1wt.eu>
References: <1417813843-7589-1-git-send-email-marius.gorski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417813843-7589-1-git-send-email-marius.gorski@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 10:10:43PM +0100, Mariusz Gorski wrote:
> Get rid of magic numbers in LCD commands and replace them with defined
> values, so that it's more obvious that the commands are doing.
> 
> Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>

I didn't remember I wrote something that awful! Obvious ack.

Acked-by: Willy Tarreau <w@1wt.eu>

Thanks,
willy

