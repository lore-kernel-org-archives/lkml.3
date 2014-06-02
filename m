Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaFBVoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:44:03 -0400
Received: from void.printf.net ([89.145.121.20]:34974 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbaFBVoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:44:00 -0400
From: Chris Ball <chris@printf.net>
To: Mike Turquette <mturquette@linaro.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-next\@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?Q?David_Lanzend=C3=B6rfer?= <david.lanzendoerfer@o2s.ch>,
        "Stephen Rothwell" <sfr@canb.auug.org.au>,
        "Hans de Goede" <hdegoede@redhat.com>
Subject: Re: linux-next: build failure after merge of the mmc tree
In-Reply-To: <20140602214039.10062.15077@quantum> (Mike Turquette's message of
	"Mon, 02 Jun 2014 14:40:39 -0700")
References: <20140530132324.757076ca@canb.auug.org.au>
	<CAPDyKFqp=quWV17MGZfvgZA-J_KPsWkza184+bjez_MQpOx6Xg@mail.gmail.com>
	<20140602214039.10062.15077@quantum>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Mon, 02 Jun 2014 22:43:56 +0100
Message-ID: <86wqczoulf.fsf@void.printf.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 02 2014, Mike Turquette wrote:
>> Hi Mike, Chris,
>> 
>> So, the proper thing would be to let Mike to carry the above patch
>> though his clk tree instead.
>> 
>> Could we arrange that?
>
> I'm happy to take it with Chris' Acked-by.

Thanks, please do:

Acked-by: Chris Ball <chris@printf.net>

(Ulf is now MMC co-maintainer so his ack works too.)

- Chris.
-- 
Chris Ball   <http://printf.net/>
