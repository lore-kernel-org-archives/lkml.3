Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab3J2XSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 19:18:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39731 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab3J2XSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 19:18:42 -0400
Date: Tue, 29 Oct 2013 16:18:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 1/8] mei: debugfs: validate dev is not null
Message-ID: <20131029231841.GA30410@kroah.com>
References: <1382382343-12066-1-git-send-email-tomas.winkler@intel.com>
 <1382382343-12066-2-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382382343-12066-2-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 10:05:36PM +0300, Tomas Winkler wrote:
> make static analyzer happy

That's a stupid analyzer.

Sorry, this case can never be true, so don't check for it.  Fix your
analyzer.

> and validate dev argument before dereferencing

Again, no need to do so, it's always set properly.

sorry, I can't take this.

greg k-h
