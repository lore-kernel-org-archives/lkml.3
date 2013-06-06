Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab3FFTst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 15:48:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab3FFTss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 15:48:48 -0400
Date: Thu, 6 Jun 2013 12:48:47 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: Re: [RFC PATCH v1 4/4] firmware loader: don't allow to request
 firmware via relative path
Message-ID: <20130606194847.GB4526@kroah.com>
References: <1370520110-32293-1-git-send-email-ming.lei@canonical.com>
 <1370520110-32293-5-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370520110-32293-5-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 08:01:50PM +0800, Ming Lei wrote:
> It isn't a good pratice to request firmware via relative path, also
> might have security issue, so don't do it.

What would the security issue be?  You are letting the person who build
the kernel specify this, so they can put whatever they want in here, a
'..' isn't going to keep them from being able to do "bad" things if they
really want to.

thanks,

greg k-h
