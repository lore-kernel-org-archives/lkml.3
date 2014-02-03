Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaBCJ6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 04:58:48 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:33662 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaBCJ6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 04:58:46 -0500
MIME-Version: 1.0
In-Reply-To: <52ec195e.P8S/D298ZeaBLTvn%akpm@linux-foundation.org>
References: <52ec195e.P8S/D298ZeaBLTvn%akpm@linux-foundation.org>
Date: Mon, 3 Feb 2014 12:58:45 +0300
Message-ID: <CACVxJT-HUXmBepz-GW3T1+ANkSxt80=1-kNFyHLdk+RRjHaWQQ@mail.gmail.com>
Subject: Re: + mm-utilc-add-kstrimdup.patch added to -mm tree
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: mm-commits@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Joe Perches <joe@perches.com>, sebastian.capella@linaro.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 1, 2014 at 12:45 AM,  <akpm@linux-foundation.org> wrote:
> kstrimdup() creates a whitespace-trimmed duplicate of the passed in
> null-terminated string.  This is useful for strings coming from sysfs that
> often include trailing whitespace due to user input.

I think kernel should be strict in what it accepts, otherwise
case-insensivity and
what not will be added some day.

Shell will trim whitespace for you.
