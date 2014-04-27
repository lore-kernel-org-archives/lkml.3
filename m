Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaD0RaE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:30:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaD0RaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:30:01 -0400
Date: Sun, 27 Apr 2014 10:30:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: Re: [PATCH 46/47] staging/lustre: Fix unsafe userspace access in
 many proc files
Message-ID: <20140427173045.GA28735@kroah.com>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
 <1398618431-29757-47-git-send-email-green@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398618431-29757-47-git-send-email-green@linuxhacker.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 01:07:10PM -0400, Oleg Drokin wrote:
> Apparently we are pretty bad about verifying our buffers passed
> from userspace.

Understatement of the day...
