Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900AbaIESsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 14:48:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41272 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaIESsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 14:48:22 -0400
Date: Fri, 5 Sep 2014 11:48:21 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dmitry Voytik <voytikd@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: binder: cmd_name must be initialised
Message-ID: <20140905184821.GB23874@kroah.com>
References: <1409932944-19528-1-git-send-email-voytikd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409932944-19528-1-git-send-email-voytikd@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 08:02:24PM +0400, Dmitry Voytik wrote:
> Variable cmd_name must be initialised as variable name is.

Why?  What bug does this fix?  Have you tested this change?  Does this
cause binder to now act differently than before?

thanks,

greg k-h
