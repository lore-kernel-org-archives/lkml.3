Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbaIXILu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:11:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42517 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbaIXILp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:11:45 -0400
Date: Tue, 23 Sep 2014 23:00:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 10/10] mei: move mei_hbm_hdr function from hbm.h
 the hbm.c
Message-ID: <20140924060018.GB24238@kroah.com>
References: <1409122772-19906-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409122772-19906-1-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 09:59:32AM +0300, Tomas Winkler wrote:
> mei_hbm_hder helper function is only used in hbm.c
> so there is no need to define it in a header file
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
> V2: fix kdoc

No V2 in the subject, so it got dropped :(

