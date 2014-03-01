Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaCAAP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 19:15:59 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:62785 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaCAAP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 19:15:58 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1393621530.git.shuah.kh@samsung.com>
References: <cover.1393621530.git.shuah.kh@samsung.com>
Date: Fri, 28 Feb 2014 19:15:57 -0500
Message-ID: <CAGoCfizyn32WqWRfDEHfv0CAus37G2MRo13k7RnQMs6zNujfvA@mail.gmail.com>
Subject: Re: [PATCH 0/3] media/drx39xyj: fix DJH_DEBUG path null pointer
 dereferences, and compile errors.
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 4:22 PM, Shuah Khan <shuah.kh@samsung.com> wrote:
> This patch series fixes null pointer dereference boot failure as well as
> compile errors.

Seems kind of strange that I wasn't on the CC for this, since I was
the original author of all that code (in fact, DJH are my initials).

Mauro, did you strip off my authorship when you pulled the patches from my tree?

The patches themselves look sane, and I will send a formal Acked-by
once I can get in front of a real computer.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
