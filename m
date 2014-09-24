Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbaIXIQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:16:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbaIXIQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:16:21 -0400
Date: Tue, 23 Sep 2014 23:32:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dexuan Cui <decui@microsoft.com>
Cc: linux-kernel@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        haiyangz@microsoft.com
Subject: Re: [PATCH v2] Tools: hv: vssdaemon: ignore the EBUSY on multiple
 freezing the same partition
Message-ID: <20140924063203.GA29621@kroah.com>
References: <1411448455-12768-1-git-send-email-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411448455-12768-1-git-send-email-decui@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 10:00:55PM -0700, Dexuan Cui wrote:
> v2: I added "errno = 0;" in the ioctl()

That does not belong in the changelog, put it below the --- line.

Also, you need a changelog description here, it can't be empty.

greg k-h
