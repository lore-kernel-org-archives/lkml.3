Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaIMAMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 20:12:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbaIMAMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 20:12:54 -0400
Date: Fri, 12 Sep 2014 17:12:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rustad, Mark D" <mark.d.rustad@intel.com>
Cc: Michal Nazarewicz <mina86@mina86.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hagen Paul Pfeifer <hagen@jauu.net>,
        "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] kernel.h: use __COUNTER__ in min and max macros to
 avoid -Wshadow warnings
Message-Id: <20140912171252.a6b651d9ab06edc97c4ff67d@linux-foundation.org>
In-Reply-To: <19E5FFA3-9630-4FD7-8E8A-2754D14AFEC2@intel.com>
References: <1410471576-12053-1-git-send-email-mina86@mina86.com>
	<1410471576-12053-2-git-send-email-mina86@mina86.com>
	<20140912154013.47dad90e7519146c6da115e5@linux-foundation.org>
	<19E5FFA3-9630-4FD7-8E8A-2754D14AFEC2@intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014 23:43:51 +0000 "Rustad, Mark D" <mark.d.rustad@intel.com> wrote:

> Do you mean the number of warnings enabled, or the number of warning messages being generated?

The latter.

My problem is I use crufty old compilers so a number of the warnings I
see aren't seen by sane people and it' snot worth mucking up the source
to fix them.

otoh crufty new compilers add warnings which I won't see...
