Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbaEHJFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 05:05:25 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:46634 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbaEHJFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 05:05:18 -0400
Date: Thu, 8 May 2014 11:05:08 +0200
From: Julian Andres Klode <jak@jak-linux.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [patch v2] Documentation/email-clients.txt: add a section about
 git
Message-ID: <20140508090508.GA16423@jak-x230>
Mail-Followup-To: Julian Andres Klode <jak@jak-linux.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Randy Dunlap <rdunlap@infradead.org>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <536A5A1E.6070004@codeaurora.org>
 <20140508084412.GA20398@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508084412.GA20398@mwanda>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 11:44:12AM +0300, Dan Carpenter wrote:
> +as raw text including all the headers.  Run `cat raw_email.txt | git am`

`cat raw_email.txt | git am` seems a bit pointless. Why not simply
`git am raw_email.txt`? `git am < raw_email.txt` does the same too
and avoids the useless cat as well. 

No point in running two processes when the same can be done in a
simpler way in one process, IMO.

-- 
Julian Andres Klode  - Debian Developer, Ubuntu Member

See http://wiki.debian.org/JulianAndresKlode and http://jak-linux.org/.

Please do not top-post if possible.
