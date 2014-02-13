Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaBMMkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 07:40:11 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:40987 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbaBMMkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 07:40:09 -0500
Date: Thu, 13 Feb 2014 12:40:02 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: Jean Delvare <jdelvare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org, Guenter Roeck <linux@roeck-us.net>
Subject: Re: [lm-sensors] [RFC PATCH] hwmon: (max6650) Convert to be a
 platform driver
Message-ID: <20140213124002.GA3403@lee--X1>
References: <1392281438-31836-1-git-send-email-lpapp@kde.org>
 <20140213095817.GD32508@lee--X1>
 <20140213111530.2a2b4982@endymion.delvare>
 <CAOMwXhML8LvDCzmk1ZVT+7cARj9C3VtxERWBgOPM9vTc6qQXZQ@mail.gmail.com>
 <CAOMwXhOv-as1W69wcSno49jEXsXWZZ7odnu8og-vgnDwRTJ4sA@mail.gmail.com>
 <20140213113313.GL32508@lee--X1>
 <CAOMwXhMNHqXnzR0YHF9rx710JbaL3YFn=3cLf_WdNkCx7hbZug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMwXhMNHqXnzR0YHF9rx710JbaL3YFn=3cLf_WdNkCx7hbZug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> http://comments.gmane.org/gmane.linux.kernel/1645251
> 
> Step 2 did not happen. I did not get any review for my change. I
> literally submitted that within a couple of hours after the request.
> 
> Could you please tell me what was wrong with that change, and why I
> did not get any respect not to "xargs rm -rf" my work in that area? I
> believe I was ignored instead of improving the change, and someone
> else tried to address the same thing. There was no argument in that
> thread. It was a technical change. I personally do not feel happy
> about it.

Let's start again.

Rebase your work on top of the HWMON tree on kernel.org and resubmit
the entire set. If rebasing takes you more than 20 mins, you're
probably doing it wrong. Ensure you submit the entire patchset with a
nice cover letter and all the patches dangling (shallow threaded) from
it. If you don't know how to do that look at `git send-email --help`
and search for "thread", "annotate" and "compose". Keep submitting
them to your own (and only your own) email address until it looks
correct, _then_ submit to the MLs CC'ing all of the maintainers on all
of the patches.

Submission should look like this:

  [PATCH 0/x] Patch-set title
   \->[PATCH 1/x] mfd: Patch title
   |->[PATCH ./x] hwmon: Patch title
   |->[PATCH x/x] gpio/pinctrl: Patch title

We'll give you constructive reviews and you'll ask questions (not
arguments) and resubmit.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
