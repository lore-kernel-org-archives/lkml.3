Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaLCFPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 00:15:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaLCFPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 00:15:40 -0500
Date: Tue, 2 Dec 2014 21:14:16 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kevin Pietsch <kevinpietsch@gmail.com>
Cc: Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Staging: ft1000: fix whitespace and brace coding
 style issues
Message-ID: <20141203051416.GB7382@kroah.com>
References: <1417580722-21899-1-git-send-email-kevinpietsch@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417580722-21899-1-git-send-email-kevinpietsch@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 11:25:22PM -0500, Kevin Pietsch wrote:
> Removed braces from single line if, else, for statements.
> Replaced space indents with tabs. Fixed whitespace errors around operators.

That's a whole lot of different things to do in one patch.

Please, one patch per "thing" you do, break this up into a series of
patches that are reviewable.

thanks,

greg k-h
