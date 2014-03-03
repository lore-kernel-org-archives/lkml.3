Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbaCCHUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 02:20:47 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:39963 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbaCCHUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 02:20:43 -0500
MIME-Version: 1.0
In-Reply-To: <CA+C-WL-pnQne-Cz8MuSFPpcHH33ARbRRm-R6VT9aEKzgNHZQQg@mail.gmail.com>
References: <1393432706-25708-1-git-send-email-rashika.kheria@gmail.com>
	<20140226164142.GA18079@thin>
	<CAMpEsFFjR2e_kDn9-QuKcS3RjsSmru9XGjXqXXdO7sYeWdh9dw@mail.gmail.com>
	<20140226170847.GA18427@thin>
	<CAKohpomqu22Pt5_wYV3u2uC36AgfmrkvxLtJCGakdodEQFE-jQ@mail.gmail.com>
	<CA+C-WL-pnQne-Cz8MuSFPpcHH33ARbRRm-R6VT9aEKzgNHZQQg@mail.gmail.com>
Date: Mon, 3 Mar 2014 12:50:43 +0530
Message-ID: <CAKohpok3UZbQZBFM5FWP3tXFDGHm+j3-zP-rYUCF1fPTxAYp9g@mail.gmail.com>
Subject: Re: [PATCH v2] drivers: cpufreq: Mark function as static in cpufreq.c
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Patrick Palka <patrick@parcs.ath.cx>
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 March 2014 09:12, Patrick Palka <patrick@parcs.ath.cx> wrote:
> -Wmissing-prototypes warns when a non-static function is defined
> before a corresponding prototype (usually inside an included header
> file) is declared.  In such a case, it is impossible to reference the
> non-static function from another file, and therefore the function
> should be marked static (usually).  Hope that makes sense!

I understand that it should be made static as we don't have a
prototype in any other header file, but I thought we shouldn't
get the warning we are getting.

warning: no previous prototype for 'show_boost'

Because we have prototype/definition of function before it is used.
Maybe a warning like:

local function should be marked static could have been there ;)
