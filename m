Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaCEFJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 00:09:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbaCEFJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 00:09:07 -0500
Date: Tue, 4 Mar 2014 21:09:27 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jon Ringle <jringle@gridpoint.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add option to build with -O3
Message-ID: <20140305050927.GA8534@kroah.com>
References: <1393977709-9809-1-git-send-email-jringle@gridpoint.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393977709-9809-1-git-send-email-jringle@gridpoint.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 07:01:49PM -0500, Jon Ringle wrote:
> +config CC_OPTIMIZE_FOR_SPEED
> +    bool "Optimze for speed (-O3)"
> +    help
> +      Enabling this option will pass "-O3" to gcc
> +      resulting in a larger kernel (but possibly faster)

Are you sure about that?  Have you measured it?

