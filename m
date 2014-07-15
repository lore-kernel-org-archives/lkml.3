Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbaGON43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:56:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaGON41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:56:27 -0400
Date: Tue, 15 Jul 2014 06:56:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: sam-the-6 <asadi.samuel@gmail.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 92/93] Staging: comedi: 8255: fixed by adding an empthy
 line
Message-ID: <20140715135605.GB18292@kroah.com>
References: <1405394144-26007-1-git-send-email-asadi.samuel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405394144-26007-1-git-send-email-asadi.samuel@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 06:15:44AM +0300, sam-the-6 wrote:
> From: Sam Asadi <asadi.samuel@gmail.com>
> 
> fixed a coding style issue.

Your Subject: does not match the body of the patch at all, why not?

Please be descriptive as to what you are doing.

Also, only do one thing per patch, and "one thing" is NOT "fix all
coding style issues".

Please redo this whole series, starting with the numbering of them, and
break them up into individual changes, not large patches.

thanks,

greg k-h
