Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab3DSR6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 13:58:49 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:52076 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab3DSR6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 13:58:48 -0400
Date: Fri, 19 Apr 2013 10:58:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Bill Nottingham <notting@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mei: reseting -> resetting
Message-ID: <20130419175845.GA11486@kroah.com>
References: <1366318791-10509-1-git-send-email-notting@redhat.com>
 <5B8DA87D05A7694D9FA63FD143655C1B01F01AA9@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B01F01AA9@HASMSX106.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 09:01:25PM +0000, Winkler, Tomas wrote:
> > 
> > This enum leaks out to userspace via error messages, so fix the spelling.
> > 
> > Signed-off-by: Bill Nottingham <notting@redhat.com>
> ACK

Why do you ack a patch that doesn't apply?  :)

thanks,

greg k-h
