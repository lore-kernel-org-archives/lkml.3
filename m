Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab3F1WmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 18:42:17 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:55415 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab3F1WmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 18:42:16 -0400
MIME-Version: 1.0
In-Reply-To: <1372450451-8790-1-git-send-email-lszubowi@redhat.com>
References: <1372450451-8790-1-git-send-email-lszubowi@redhat.com>
Date: Fri, 28 Jun 2013 15:42:15 -0700
Message-ID: <CA+8MBbJvzxeq+LHzFRGqRvNPwcmxUf_8ksXRnKYozFVpVuZdsA@mail.gmail.com>
Subject: Re: [PATCH 0/3] acpi: Eliminate misleading erst pstore console message
From: Tony Luck <tony.luck@gmail.com>
To: Lenny Szubowicz <lszubowi@redhat.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        n.hamaguchi@jp.fujitsu.com, Don Zickus <dzickus@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 1:14 PM, Lenny Szubowicz <lszubowi@redhat.com> wrote:
> On systems that have a valid ACPI ERST table, if the pstore.backend kernel
> parameter selects a specific facility other than erst, then during boot the
> following console message is displayed:
>
>     ERST: Could not register with persistent store

Applied (using revised version of part 1).

Thanks

-Tony
