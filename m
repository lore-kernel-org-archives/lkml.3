Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbaAISnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 13:43:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51360 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaAISm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:42:58 -0500
Date: Thu, 9 Jan 2014 10:43:29 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Borg <cyborg101010@gmail.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DAS6042: Fixing typeo.
Message-ID: <20140109184329.GC10563@kroah.com>
References: <1388683520-25555-1-git-send-email-cyborg101010@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388683520-25555-1-git-send-email-cyborg101010@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 05:25:20PM +0000, Joe Borg wrote:
> Fixing foo * bar should be foo *bar.
> 
> Fixed by Joe Borg root@josephb.org

Same comments as the last, I can't take this :(
