Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaLVB4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 20:56:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbaLVB4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 20:56:17 -0500
Date: Sun, 21 Dec 2014 17:56:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: mathieu.poirier@linaro.org
Cc: jason@lakedaemon.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: skein: Fixing various coding style problems
Message-ID: <20141222015614.GA2386@kroah.com>
References: <1419206988-27331-1-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419206988-27331-1-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 05:09:48PM -0700, mathieu.poirier@linaro.org wrote:
> From: Mathieu Poirier <mathieu.poirier@linaro.org>
> 
> Fixing errors related to the usage of do {} while (0) loop
> in single statement macros, trailing semicolon in macros and
> trailing whitespace.

That's a lot of things all at once, please break this up into individual
patches, each one only doing one thing.

thanks,

greg k-h
