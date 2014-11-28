Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335AbaK1VAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 16:00:50 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:43490 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaK1VAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 16:00:49 -0500
Date: Fri, 28 Nov 2014 22:00:43 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Laurent Georget <laurent.georget@supelec.fr>
Cc: mtk.manpages@gmail.com, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] adjtimex.2: add explanation about ADJ_TAI action
Message-ID: <20141128210043.GB14432@localhost.localdomain>
References: <54787B5C.1080802@supelec.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54787B5C.1080802@supelec.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 02:40:44PM +0100, Laurent Georget wrote:
> @@ -101,7 +99,19 @@ combination of zero or more of the following bits:
>  Ordinary users are restricted to a zero value for
>  .IR modes .
>  Only the superuser may set any parameters.
> +.PP
> +Support for TAI (Atomic International Time, for a complete explanation
> about
> +what it is and what is the difference between TAI and UTC, see
> +.UR http://www.bipm.org/en/bipm/tai/tai.html
> +.I BIPM
> +.UE )
> +has been added in version 2.6.29. For any clock, the TAI offset may

Not for "any clock", just for CLOCK_REALTIME.

> +be calculated by adding a value to the UTC offset which is updated when a
> +leap second is added or deleted.
>  .br
> +All the offsets in the timex structure are expressed between the value
> of the
> +clock and the corresponding value (e.g. TAI offset is the difference
> between
> +the clock and the TAI, not between TAI and another value such as UTC).

The TAI offset is just (TAI - UTC). That's all.

Thanks,
Richard
