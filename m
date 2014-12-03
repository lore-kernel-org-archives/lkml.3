Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaLCTEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 14:04:11 -0500
Received: from 1wt.eu ([62.212.114.60]:32481 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaLCTEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 14:04:09 -0500
Date: Wed, 3 Dec 2014 20:04:03 +0100
From: Willy Tarreau <w@1wt.eu>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: panel: Remove unused variable
Message-ID: <20141203190403.GB23632@1wt.eu>
References: <1417632827-17343-1-git-send-email-marius.gorski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417632827-17343-1-git-send-email-marius.gorski@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 07:53:47PM +0100, Mariusz Gorski wrote:
> Remove lcd.left_shift because it is only written to at some places but
> never read from.

Good catch, I think some code got dropped at some point because it
was used to shift the window of displayed text. Anyway nobody seems
to be missing it :-)

Acked-by: Willy Tarreau <w@1wt.eu>

Willy

