Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbaGUVRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:17:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbaGUVRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:17:50 -0400
Date: Mon, 21 Jul 2014 14:17:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Igor Bezukh <igbzkh@gmail.com>
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: vt6655: remove redundant comments
Message-ID: <20140721211750.GA7550@kroah.com>
References: <1405834910-3098-1-git-send-email-igbzkh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405834910-3098-1-git-send-email-igbzkh@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 08:41:50AM +0300, Igor Bezukh wrote:
> Clean redundant comments in the code.

You also messed with some strings :(

Which would have been fine, in a separate patch.  Please break this up
into at least 2 different patches, each only doing one type of thing.

thanks,

greg k-h
