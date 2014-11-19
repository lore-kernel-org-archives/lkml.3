Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980AbaKSVM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:12:58 -0500
Received: from 1wt.eu ([62.212.114.60]:55783 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932442AbaKSVM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:12:56 -0500
Date: Wed, 19 Nov 2014 22:12:52 +0100
From: Willy Tarreau <w@1wt.eu>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] staging: panel: Refactor panel initialization
Message-ID: <20141119211252.GH30756@1wt.eu>
References: <1416429531-11088-1-git-send-email-marius.gorski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416429531-11088-1-git-send-email-marius.gorski@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mariusz,

On Wed, Nov 19, 2014 at 09:38:42PM +0100, Mariusz Gorski wrote:
> This set of patches focuses on making current initialization
> process easier to understand - especially it tries to emphasize
> what are the priorities of the params coming from different
> sources (Kconfig values, device profiles and module param values
> set on loading). I paid attention not to change to behaviour of
> the code itself (at least for now), so all hacky places are kept.
> 
> v2: Don't introduce new macros for param value check

(...)

Great work, the code is already significantly cleaner now, thanks
for doing this work! I've acked all the new patches.

Best regards,
Willy

