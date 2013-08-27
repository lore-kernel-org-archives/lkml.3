Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab3H0Xo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 19:44:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43205 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab3H0XoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 19:44:25 -0400
Date: Tue, 27 Aug 2013 16:46:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Iker Pedrosa <ikerpedrosam@gmail.com>
Cc: pavel@ucw.cz, devel@driverdev.osuosl.org, harsh1kumar@gmail.com,
        linux-kernel@vger.kernel.org, mujeeb.adil@gmail.com,
        justinmattock@gmail.com, dan.carpenter@oracle.com
Subject: Re: [PATCH 05/24] Staging: winbond: phy_calibration: fixed some
 lines over 80 characters
Message-ID: <20130827234643.GA7317@kroah.com>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
 <1377529823-5116-6-git-send-email-ikerpedrosam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377529823-5116-6-git-send-email-ikerpedrosam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 05:10:04PM +0200, Iker Pedrosa wrote:
> Second of the patches that fixes the lines over 80 characters in phy_calibration.c
> 
> Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>

This Subject: is identical to the previous patch, not good.

You also do that for 4 other patches in this series :(

Can you please redo all of these, fixing the subjects, and the build
errors (which wasn't good at all), and resend them?

thanks,

greg k-h
