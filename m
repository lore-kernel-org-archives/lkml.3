Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab3DSGL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 02:11:57 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55668 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979Ab3DSGLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 02:11:55 -0400
Date: Thu, 18 Apr 2013 23:11:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>,
        matt@console-pimps.org, matthew.garrett@nebula.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, darren.hart@intel.com,
        josh@joshtriplett.org, mingo@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode V2
Message-ID: <20130419061146.GA16775@kroah.com>
References: <1366236341-22615-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie>
 <20130419055813.GA16443@kroah.com>
 <bb2db2a1-835f-47d0-830d-0dd3785343a9@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb2db2a1-835f-47d0-830d-0dd3785343a9@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 11:00:27PM -0700, H. Peter Anvin wrote:
> The only real use for command line options is to be able to get users
> to test something during troubleshooting.

Ok, but the option shouldn't be used to "solve" the problem.

greg k-h
