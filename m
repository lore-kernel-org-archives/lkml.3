Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab3DPL2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 07:28:50 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:42276 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab3DPL2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 07:28:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130416112035.GD26958@opensource.wolfsonmicro.com>
References: <1366015230-18243-1-git-send-email-ks.giri@samsung.com>
	<20130416112035.GD26958@opensource.wolfsonmicro.com>
Date: Tue, 16 Apr 2013 16:58:47 +0530
Message-ID: <CAKrE-Kd4Vis0-V_n8zEzqJVBbEYvTiYS8hY_7s7AnUqaK2tFCQ@mail.gmail.com>
Subject: Re: [PATCH V4 2/5] spi: s3c64xx: added support for polling mode
From: Girish KS <girishks2000@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        t.figa@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 4:50 PM, Mark Brown <broonie@kernel.org> wrote:
> On Mon, Apr 15, 2013 at 02:10:27PM +0530, Girish K S wrote:
>> From: Girish K S <girishks2000@gmail.com>
>>
>> The 64xx spi driver supports partial polling mode.
>> Only the last chunk of the transfer length is transferred
>> or recieved in polling mode.
>
> I'm missing patch 1 of this series.

its already  merged to stable tree after your review
