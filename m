Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbaCJUro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:47:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbaCJUrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:47:42 -0400
Date: Mon, 10 Mar 2014 13:47:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, linux-arm-msm@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/6] rtc: pm8xxx: use regmap API for register
 accesses
Message-Id: <20140310134741.e5b97d12d47e1b990501f8bc@linux-foundation.org>
In-Reply-To: <1394477089-3996-3-git-send-email-joshc@codeaurora.org>
References: <1394477089-3996-1-git-send-email-joshc@codeaurora.org>
	<1394477089-3996-3-git-send-email-joshc@codeaurora.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014 13:44:45 -0500 Josh Cartwright <joshc@codeaurora.org> wrote:

> Now that the parent mfd driver has been made to work again, and has been
> reworked to create a regmap instance intended for it's children to use,
> rework the pm8xxx driver to use the regmap API for it's register
> accesses.

Do we need a 

	depends on REGMAP

in Kconfig?
