Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab3JXUaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 16:30:11 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:35750 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab3JXUaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 16:30:09 -0400
Date: Thu, 24 Oct 2013 15:30:07 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH trace-cmd 1/5] trace-cmd/listen: Remove use of
 sighandler_t
Message-ID: <20131024203007.GB8006@thinkpad-t410>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org
References: <1382642074-15567-1-git-send-email-seth.forshee@canonical.com>
 <1382642074-15567-2-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382642074-15567-2-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 02:14:30PM -0500, Seth Forshee wrote:
> sighandler_t is a GNU extension and may not be defined if
> _GNU_SOURCE is not set. To minimize the potential for build
> problems, change signal_setup() to declare its handle argument
> the same way struct sigaction declares the sa_handler member.

I just saw that you've already got a commit to define _GNU_SOURCE on
master. I was packaging v2.2.1 and didn't notice it, so you can ignore
this one.

