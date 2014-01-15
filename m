Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbaAOXde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 18:33:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44876 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbaAOXd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 18:33:29 -0500
Date: Wed, 15 Jan 2014 15:33:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sangjung Woo <sangjung.woo@samsung.com>
Cc: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Documentation / CPU hotplug: Fix the typo in example
 code
Message-Id: <20140115153328.49a61c6bcd5897fad89af35c@linux-foundation.org>
In-Reply-To: <1389762626-28982-1-git-send-email-sangjung.woo@samsung.com>
References: <1389762626-28982-1-git-send-email-sangjung.woo@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jan 2014 14:10:26 +0900 Sangjung Woo <sangjung.woo@samsung.com> wrote:

> As the notifier_block name (i.e. foobar_cpu_notifer) is different from
> the parameter (i.e.foobar_cpu_notifier) of register function, that is
> definitely error and it also makes readers confused.
> 

btw, that document doesn't mention hotcpu_notifier(), which is actually
the preferred means of registration.  Because it causes all the hotplug
code to be elided when CONFIG_HOTPLUG_CPU=n, without using ifdefs.

