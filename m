Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbaLSPlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 10:41:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaLSPls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 10:41:48 -0500
Date: Fri, 19 Dec 2014 07:41:47 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Eduardo Barretto <edusbarretto@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Staging: wlan-ng: hfa384x_usb: fixed an 'else'
 statement coding style issue
Message-ID: <20141219154147.GB19077@kroah.com>
References: <1418955506-30099-1-git-send-email-edusbarretto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418955506-30099-1-git-send-email-edusbarretto@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 12:18:26AM -0200, Eduardo Barretto wrote:
> Checkpatch was complaining about the else statement because the if statement had a return '1' call. Taking a look at the function which this else statement belongs, you can see that it has an switch case statement.
> The main idea of the function is to return '1' if you get into any of the cases (including the default case where the "problematic" if/else statement is declared).
> If any of the cases is not sufficient the function should return '0', so the else statement that checkpath was complaining could be removed, and what was done inside this else statement can be done outside the switch case statement and then we return '0'.
> This way we have a cleaner code and no checkpatch error complaints.

Verbose is good, but please wrap your lines at 72 columns.  And this
might have been a bit too verbose :)

thanks,

greg k-h
