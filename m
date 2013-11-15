Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab3KOXeD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:34:03 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:50797 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab3KOXd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:33:56 -0500
MIME-Version: 1.0
In-Reply-To: <20131115231548.60418E0090@blue.fi.intel.com>
References: <1383833644-27091-1-git-send-email-kirill.shutemov@linux.intel.com>
	<CA+8MBbL-WpcC6_wfZeFW6Buqq0p1PStH5ScF-USHae40H3MXfg@mail.gmail.com>
	<CA+8MBbJR+AbGY41=TMOfJUd2u927ADa8O_-12sFUcNYnN34oMw@mail.gmail.com>
	<20131115231548.60418E0090@blue.fi.intel.com>
Date: Fri, 15 Nov 2013 15:33:55 -0800
Message-ID: <CA+8MBbLNbchh67DfCo_ntZ42yYUy4ttn8uODV-mEyG9KhFwcNg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: Properly separate the bloated ptl from the
 regular case
From: Tony Luck <tony.luck@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 3:15 PM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> -#include <linux/spinlock.h>
> +#include <linux/spinlock_types.h>

Awesome!

Tested-by: Tony Luck <tony.luck@intel.com>

-Tony
