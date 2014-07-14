Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaGNAIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 20:08:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55076 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaGNAIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 20:08:36 -0400
Date: Sun, 13 Jul 2014 17:13:06 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Lucas Tanure <tanure@linux.com>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging: android: Clean up else statement from
 binder_send_failed_reply
Message-ID: <20140714001306.GA6524@kroah.com>
References: <20140713232513.GA15486@archDesk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140713232513.GA15486@archDesk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2014 at 08:25:13PM -0300, Lucas Tanure wrote:
> Kernel coding style. Remove useless else statement after return.
> Changes from v1 and v2: Fix warning for mixed declarations and code.
> Declaration of "struct binder_transaction *next" made outside of while,
> and initialized with NULL. 

Why did you initialize it with NULL?  It's not needed to do this, right?

4th time's a charm?

thanks,

greg k-h
