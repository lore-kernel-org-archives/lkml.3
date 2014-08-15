Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaHOP0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 11:26:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40586 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbaHOP0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 11:26:44 -0400
Date: Fri, 15 Aug 2014 14:55:06 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ramesh Basukala <basukalaramesh@gmail.com>
Cc: lisa@xenapiadmin.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: bmc: fix coding style warning
Message-ID: <20140815065506.GA26102@kroah.com>
References: <20140814012006.GA8776@kroah.com>
 <1408025504-19100-1-git-send-email-basukalaramesh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408025504-19100-1-git-send-email-basukalaramesh@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 10:11:44AM -0400, Ramesh Basukala wrote:
> This is a patch to the vendorspecificextn.c that fixes coding style
> warning message line over 80 characters found by checkpatch.pl script.
> I am submitting this patch as required by Eudyptula Challenge.

Minor nit, your subject is wrong, the driver is 'bcm' not 'bmc' :)

