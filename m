Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162845Ab3DEWDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 18:03:07 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:58791 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162779Ab3DEWDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 18:03:05 -0400
Date: Fri, 5 Apr 2013 15:03:03 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Bill Pemberton <wfp5p@virginia.edu>,
        Joe Perches <joe@perches.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH] staging/adt7316 Fix some 'interesting' string operations
Message-ID: <20130405220303.GA31802@kroah.com>
References: <515df29417437372eb@agluck-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515df29417437372eb@agluck-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 02:37:24PM -0700, Luck, Tony wrote:
> Calling memcmp() to check the value of the first byte in a string is overkill.
> Just use buf[0] == '1' or buf[0] != '1' as appropriate.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>

I'll let Jonathan take this through his tree which eventually makes it
to mine.

thanks,

greg k-h
